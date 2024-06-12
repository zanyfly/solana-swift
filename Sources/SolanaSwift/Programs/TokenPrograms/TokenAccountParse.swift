
public protocol TokenAccountParse: Decodable {
    var mint: String { get }
    var owner: String { get }
}
