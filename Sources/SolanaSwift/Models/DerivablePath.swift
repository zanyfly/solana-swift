import Foundation

public struct DerivablePath: Hashable, Codable {
    // MARK: - Nested type

    public enum DerivableType: String, CaseIterable, Codable {
        case bip44Change
        case bip44
        case deprecated

        public var prefix: String {
            switch self {
            case .deprecated:
                return "m/501'"
            case .bip44, .bip44Change:
                return "m/44'/501'"
            }
        }
    }

    // MARK: - Properties

    public let type: DerivableType
    public let walletIndex: Int
    public let accountIndex: Int?

    public init(type: DerivablePath.DerivableType, walletIndex: Int, accountIndex: Int? = nil) {
        self.type = type
        self.walletIndex = walletIndex
        self.accountIndex = accountIndex
    }

    public static var `default`: Self {
        .init(
            type: .bip44Change,
            walletIndex: 0,
            accountIndex: 0
        )
    }

    public var rawValue: String {
        var value = type.prefix
        switch type {
        case .deprecated:
            value += "/\(walletIndex)'/0/\(accountIndex ?? 0)"
        case .bip44:
            value += "/\(walletIndex)'"
        case .bip44Change:
            value += "/\(walletIndex)'/0'"
        }
        return value
    }
}
