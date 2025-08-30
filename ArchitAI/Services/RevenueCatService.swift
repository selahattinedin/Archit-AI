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
        print("🔴 RevenueCatService: Configuring with API key: \(apiKey)")
        Purchases.logLevel = .debug
        
        let configuration = Configuration.Builder(withAPIKey: apiKey)
            .with(usesStoreKit2IfAvailable: true)
            .build()
        
        print("🔴 RevenueCatService: Configuration built successfully")
        
        Purchases.configure(with: configuration)
        print("🔴 RevenueCatService: Purchases configured")
        
        Purchases.shared.delegate = self
        print("🔴 RevenueCatService: Delegate set")
        
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
        print("🔴 RevenueCatService: Fetching offerings...")
        isLoading = true
        Purchases.shared.getOfferings { [weak self] offerings, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print("🔴 RevenueCatService: Error fetching offerings: \(error.localizedDescription)")
                    print("🔴 RevenueCatService: Error details: \(error)")
                    self?.lastErrorMessage = error.localizedDescription
                } else {
                    print("🔴 RevenueCatService: Offerings received successfully")
                    if let offerings = offerings {
                        print("🔴 RevenueCatService: Current offering: \(offerings.current?.identifier ?? "nil")")
                        print("🔴 RevenueCatService: Available packages count: \(offerings.current?.availablePackages.count ?? 0)")
                        for package in offerings.current?.availablePackages ?? [] {
                            print("🔴 RevenueCatService: Package: \(package.identifier), Type: \(package.packageType), Price: \(package.storeProduct.price)")
                        }
                    } else {
                        print("🔴 RevenueCatService: No offerings available")
                    }
                    self?.offerings = offerings
                    // İlk anda boş dönerse kısa bir gecikme ile bir kez daha dene
                    if (offerings?.current?.availablePackages.isEmpty ?? true) && (self?.offeringsRetryCount ?? 0) < 2 {
                        self?.offeringsRetryCount += 1
                        print("🔴 RevenueCatService: Retrying fetchOfferings (attempt \(self?.offeringsRetryCount ?? 0))")
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


