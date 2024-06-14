public struct TokenAccountDataParsed: TokenAccountParse {

    public let mint: String
    public let owner: String
    public let program: String
    public let amount: String
    public let decimals: Int

    enum CodingKeys: CodingKey {
        case program
        case parsed

        enum ParsedCodingKeys: String, CodingKey {
            case info
            enum InfoCodingKeys: String, CodingKey {
                case mint
                case owner
                case tokenAmount
                enum TokenAmountCodingKeys: String, CodingKey {
                    case amount
                    case decimals
                }
            }
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let parsed = try container.nestedContainer(keyedBy: CodingKeys.ParsedCodingKeys.self, forKey: .parsed)
        let info = try parsed.nestedContainer(keyedBy: CodingKeys.ParsedCodingKeys.InfoCodingKeys.self, forKey: .info)
        let tokenAmount = try info.nestedContainer(keyedBy: CodingKeys.ParsedCodingKeys.InfoCodingKeys.TokenAmountCodingKeys.self, forKey: .tokenAmount)


        self.mint = try info.decode(String.self, forKey: .mint)
        self.owner = try info.decode(String.self, forKey: .owner)
        self.program = try container.decode(String.self, forKey: .program)
        self.amount = try tokenAmount.decode(String.self, forKey: .amount)
        self.decimals = try tokenAmount.decode(Int.self, forKey: .decimals)
    }
}
