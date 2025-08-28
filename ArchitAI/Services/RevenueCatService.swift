import Foundation
import RevenueCat
import Combine

final class RevenueCatService: NSObject, ObservableObject {
    static let shared = RevenueCatService()

    @Published var isPro: Bool = false
    @Published var offerings: Offerings?
    @Published var isLoading: Bool = false
    @Published var lastErrorMessage: String?
    private var offeringsRetryCount: Int = 0

    private var cancellables: Set<AnyCancellable> = []

    private override init() {
        super.init()
        // Purchases.configure() çağrılmadan önce RevenueCat API'larına dokunmuyoruz.
    }

    func configure(apiKey: String) {
        Purchases.logLevel = .debug
        let configuration = Configuration.Builder(withAPIKey: apiKey)
            .with(usesStoreKit2IfAvailable: true)
            .build()
        Purchases.configure(with: configuration)
        Purchases.shared.delegate = self
        refreshCustomerInfo()
        fetchOfferings()
    }

    func identify(userId: String) {
        Purchases.shared.logIn(userId) { [weak self] info, _, _ in
            self?.updateEntitlements(info)
        }
    }

    func logout() {
        Purchases.shared.logOut { [weak self] info, _ in
            self?.updateEntitlements(info)
        }
    }

    func fetchOfferings() {
        isLoading = true
        Purchases.shared.getOfferings { [weak self] offerings, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.lastErrorMessage = error.localizedDescription
                } else {
                    self?.offerings = offerings
                    // İlk anda boş dönerse kısa bir gecikme ile bir kez daha dene
                    if (offerings?.current?.availablePackages.isEmpty ?? true) && (self?.offeringsRetryCount ?? 0) < 2 {
                        self?.offeringsRetryCount += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self?.fetchOfferings()
                        }
                    }
                }
            }
        }
    }

    func purchase(_ package: Package, completion: ((Bool) -> Void)? = nil) {
        isLoading = true
        Purchases.shared.purchase(package: package) { [weak self] transaction, info, error, userCancelled in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    if userCancelled == false {
                        self?.lastErrorMessage = error.localizedDescription
                    }
                    completion?(false)
                    return
                }
                self?.updateEntitlements(info)
                completion?(true)
            }
        }
    }

    func restorePurchases(completion: ((Bool) -> Void)? = nil) {
        isLoading = true
        Purchases.shared.restorePurchases { [weak self] info, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.lastErrorMessage = error.localizedDescription
                    completion?(false)
                    return
                }
                self?.updateEntitlements(info)
                completion?(self?.isPro == true)
            }
        }
    }

    func refreshCustomerInfo() {
        Purchases.shared.getCustomerInfo { [weak self] info, _ in
            self?.updateEntitlements(info)
        }
    }

    private func updateEntitlements(_ info: CustomerInfo?) {
        guard let info = info else { return }
        // Varsayılan entitlement id: "premium" (RevenueCat Dashboard'da oluşturduğunuz id ile eşleşmeli)
        let isPremiumActive = info.entitlements.active.first { key, _ in
            key.lowercased() == "premium"
        } != nil
        DispatchQueue.main.async {
            self.isPro = isPremiumActive
        }
    }
}

extension RevenueCatService: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        updateEntitlements(customerInfo)
    }
}


