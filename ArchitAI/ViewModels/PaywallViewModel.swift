import Foundation
import RevenueCat
import Combine

@MainActor
final class PaywallViewModel: ObservableObject {
    @Published var selectedPackage: Package?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var shouldDismiss = false  // Yeni: Paywall'ı kapatmak için
    
    private var cancellables = Set<AnyCancellable>()
    private let purchasesService: RevenueCatService
    
    // Completion handler for successful purchase
    var onPurchaseSuccess: (() -> Void)?
    
    init(purchasesService: RevenueCatService) {
        self.purchasesService = purchasesService
        setupBindings()
    }
    
    private func setupBindings() {
        print("🔵 PaywallViewModel: Setting up bindings...")
        
        purchasesService.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        purchasesService.$lastErrorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        // Offerings geldiğinde yıllık planı otomatik seç
        purchasesService.$offerings
            .compactMap { $0?.current }
            .sink { [weak self] offering in
                print("🔵 PaywallViewModel: Offerings received, packages count: \(offering.availablePackages.count)")
                if let annualPackage = offering.availablePackages.first(where: { $0.packageType == .annual }) {
                    print("🔵 PaywallViewModel: Annual package found, setting as selected")
                    self?.selectedPackage = annualPackage
                } else {
                    print("🔵 PaywallViewModel: No annual package found")
                }
            }
            .store(in: &cancellables)
        
        // Pro durumu değiştiğinde paywall'ı kapat
        purchasesService.$isPro
            .dropFirst() // İlk değeri skip et
            .sink { [weak self] isPro in
                print("🔵 PaywallViewModel: isPro changed to: \(isPro)")
                if isPro {
                    print("🔵 PaywallViewModel: User became Pro, setting shouldDismiss to true")
                    self?.shouldDismiss = true
                    self?.onPurchaseSuccess?()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchOfferings() {
        purchasesService.fetchOfferings()
    }
    
    func selectPackage(_ package: Package) {
        selectedPackage = package
    }
    
    func purchaseSelectedPackage() {
        guard let package = selectedPackage else { return }
        
        Task {
            // Purchase işlemi başarılı olursa shouldDismiss otomatik true olacak
            await purchasesService.purchase(package)
        }
    }
    
    func refreshOfferings() {
        purchasesService.fetchOfferings()
    }
    
    func dismissPaywall() {
        print("🔵 PaywallViewModel: dismissPaywall() called")
        shouldDismiss = true
        print("🔵 PaywallViewModel: shouldDismiss set to: \(shouldDismiss)")
    }
    
    // MARK: - Package Filtering
    
    func filteredPackages(from offering: Offering) -> [Package] {
        let allowed: Set<PackageType> = [.annual, .weekly]
        let packages = offering.availablePackages.filter { allowed.contains($0.packageType) }
        return packages.sorted { lhs, rhs in
            orderIndex(for: lhs.packageType) < orderIndex(for: rhs.packageType)
        }
    }
    
    private func orderIndex(for type: PackageType) -> Int {
        switch type {
        case .annual: return 0
        case .weekly: return 1
        default: return 99
        }
    }
    
    func packageTitle(for package: Package) -> String {
        switch package.packageType {
        case .annual: return "Annual"
        case .weekly: return "Weekly"
        default: return package.storeProduct.localizedTitle
        }
    }
    
    // MARK: - Computed Properties
    
    var hasOfferings: Bool {
        purchasesService.offerings?.current?.availablePackages.isEmpty == false
    }
    
    var currentOfferings: Offerings? {
        purchasesService.offerings
    }
    
    var isPro: Bool {
        purchasesService.isPro
    }
}
