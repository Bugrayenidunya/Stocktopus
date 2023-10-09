// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetStockDetailForTickerQuery: GraphQLQuery {
  public static let operationName: String = "GetStockDetailForTicker"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetStockDetailForTicker($ticker: String!, $timespan: String, $range: Int, $startDate: Date, $endDate: Date, $limit: Int) { stockDetail(ticker: $ticker) { __typename stockAggregates( timespan: $timespan range: $range startDate: $startDate endDate: $endDate limit: $limit ) { __typename results { __typename c o l h } } ticker name currency_name description homepage_url address { __typename address1 city state postal_code } branding { __typename logo_url } } }"#
    ))

  public var ticker: String
  public var timespan: GraphQLNullable<String>
  public var range: GraphQLNullable<Int>
  public var startDate: GraphQLNullable<Date>
  public var endDate: GraphQLNullable<Date>
  public var limit: GraphQLNullable<Int>

  public init(
    ticker: String,
    timespan: GraphQLNullable<String>,
    range: GraphQLNullable<Int>,
    startDate: GraphQLNullable<Date>,
    endDate: GraphQLNullable<Date>,
    limit: GraphQLNullable<Int>
  ) {
    self.ticker = ticker
    self.timespan = timespan
    self.range = range
    self.startDate = startDate
    self.endDate = endDate
    self.limit = limit
  }

  public var __variables: Variables? { [
    "ticker": ticker,
    "timespan": timespan,
    "range": range,
    "startDate": startDate,
    "endDate": endDate,
    "limit": limit
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("stockDetail", StockDetail?.self, arguments: ["ticker": .variable("ticker")]),
    ] }

    public var stockDetail: StockDetail? { __data["stockDetail"] }

    /// StockDetail
    ///
    /// Parent Type: `StockDetailWithAggregates`
    public struct StockDetail: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.StockDetailWithAggregates }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("stockAggregates", StockAggregates?.self, arguments: [
          "timespan": .variable("timespan"),
          "range": .variable("range"),
          "startDate": .variable("startDate"),
          "endDate": .variable("endDate"),
          "limit": .variable("limit")
        ]),
        .field("ticker", String.self),
        .field("name", String.self),
        .field("currency_name", String?.self),
        .field("description", String?.self),
        .field("homepage_url", String?.self),
        .field("address", Address?.self),
        .field("branding", Branding?.self),
      ] }

      public var stockAggregates: StockAggregates? { __data["stockAggregates"] }
      public var ticker: String { __data["ticker"] }
      public var name: String { __data["name"] }
      public var currency_name: String? { __data["currency_name"] }
      public var description: String? { __data["description"] }
      public var homepage_url: String? { __data["homepage_url"] }
      public var address: Address? { __data["address"] }
      public var branding: Branding? { __data["branding"] }

      /// StockDetail.StockAggregates
      ///
      /// Parent Type: `StockAggregates`
      public struct StockAggregates: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.StockAggregates }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("results", [Result?]?.self),
        ] }

        public var results: [Result?]? { __data["results"] }

        /// StockDetail.StockAggregates.Result
        ///
        /// Parent Type: `StockAggregatesResult`
        public struct Result: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.StockAggregatesResult }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("c", Double?.self),
            .field("o", Double?.self),
            .field("l", Double?.self),
            .field("h", Double?.self),
          ] }

          public var c: Double? { __data["c"] }
          public var o: Double? { __data["o"] }
          public var l: Double? { __data["l"] }
          public var h: Double? { __data["h"] }
        }
      }

      /// StockDetail.Address
      ///
      /// Parent Type: `StockDetailAddress`
      public struct Address: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.StockDetailAddress }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("address1", String?.self),
          .field("city", String.self),
          .field("state", String?.self),
          .field("postal_code", String?.self),
        ] }

        public var address1: String? { __data["address1"] }
        public var city: String { __data["city"] }
        public var state: String? { __data["state"] }
        public var postal_code: String? { __data["postal_code"] }
      }

      /// StockDetail.Branding
      ///
      /// Parent Type: `StockDetailBranding`
      public struct Branding: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.StockDetailBranding }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("logo_url", String?.self),
        ] }

        public var logo_url: String? { __data["logo_url"] }
      }
    }
  }
}
