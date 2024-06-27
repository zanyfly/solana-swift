import Foundation

public struct AccountMeta: Equatable, Codable, CustomDebugStringConvertible {
    public let publicKey: PublicKey
    public var isSigner: Bool
    public var isWritable: Bool

    // MARK: - Decodable

    enum CodingKeys: String, CodingKey {
        case pubkey, signer, writable, isSigner, isWritable
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicKey = try PublicKey(string: values.decode(String.self, forKey: .pubkey))
        isSigner = if values.contains(.isSigner) {
            try values.decode(Bool.self, forKey: .isSigner)
        } else {
            try values.decode(Bool.self, forKey: .signer)
        }
        isWritable = if values.contains(.isWritable) {
            try values.decode(Bool.self, forKey: .isWritable)
        } else {
            try values.decode(Bool.self, forKey: .writable)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(publicKey.base58EncodedString, forKey: .pubkey)
        try container.encode(isSigner, forKey: .isSigner)
        try container.encode(isWritable, forKey: .isWritable)
    }

    // Initializers
    public init(publicKey: PublicKey, isSigner: Bool, isWritable: Bool) {
        self.publicKey = publicKey
        self.isSigner = isSigner
        self.isWritable = isWritable
    }

    public static func readonly(publicKey: PublicKey, isSigner: Bool) -> Self {
        .init(publicKey: publicKey, isSigner: isSigner, isWritable: false)
    }

    public static func writable(publicKey: PublicKey, isSigner: Bool) -> Self {
        .init(publicKey: publicKey, isSigner: isSigner, isWritable: true)
    }

    public var debugDescription: String {
        "{\"publicKey\": \"\(publicKey.base58EncodedString)\", \"isSigner\": \(isSigner), \"isWritable\": \(isWritable)}"
    }
}
