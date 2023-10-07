// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetStocksByLimitQuery: GraphQLQuery {
  public static let operationName: String = "GetStocksByLimit"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetStocksByLimit($limit: Int, $cursor: String) { stocks(limit: $limit, cursor: $cursor) { __typename data { __typename currency_name locale name ticker type } has_more cursor } }"#
    ))

  public var limit: GraphQLNullable<Int>
  public var cursor: GraphQLNullable<String>

  public init(
    limit: GraphQLNullable<Int>,
    cursor: GraphQLNullable<String>
  ) {
    self.limit = limit
    self.cursor = cursor
  }

  public var __variables: Variables? { [
    "limit": limit,
    "cursor": cursor
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("stocks", Stocks?.self, arguments: [
        "limit": .variable("limit"),
        "cursor": .variable("cursor")
      ]),
    ] }

    public var stocks: Stocks? { __data["stocks"] }

    /// Stocks
    ///
    /// Parent Type: `StockList`
    public struct Stocks: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.StockList }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("data", [Datum].self),
        .field("has_more", Bool.self),
        .field("cursor", String?.self),
      ] }

      public var data: [Datum] { __data["data"] }
      public var has_more: Bool { __data["has_more"] }
      public var cursor: String? { __data["cursor"] }

      /// Stocks.Datum
      ///
      /// Parent Type: `Stock`
      public struct Datum: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Stock }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("currency_name", String?.self),
          .field("locale", String?.self),
          .field("name", String.self),
          .field("ticker", String.self),
          .field("type", String?.self),
        ] }

        public var currency_name: String? { __data["currency_name"] }
        public var locale: String? { __data["locale"] }
        public var name: String { __data["name"] }
        public var ticker: String { __data["ticker"] }
        public var type: String? { __data["type"] }
      }
    }
  }
}
