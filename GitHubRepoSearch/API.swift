//  This file was automatically generated and should not be edited.

import Apollo

public final class NumberOfReposQuery: GraphQLQuery {
  public static let operationString =
    "query numberOfRepos($number_of_repos: Int!) {\n  viewer {\n    __typename\n    name\n    repositories(last: $number_of_repos) {\n      __typename\n      nodes {\n        __typename\n        name\n      }\n    }\n  }\n}"

  public var number_of_repos: Int

  public init(number_of_repos: Int) {
    self.number_of_repos = number_of_repos
  }

  public var variables: GraphQLMap? {
    return ["number_of_repos": number_of_repos]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(viewer: Viewer) {
      self.init(snapshot: ["__typename": "Query", "viewer": viewer.snapshot])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(snapshot: snapshot["viewer"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("repositories", arguments: ["last": GraphQLVariable("number_of_repos")], type: .nonNull(.object(Repository.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(name: String? = nil, repositories: Repository) {
        self.init(snapshot: ["__typename": "User", "name": name, "repositories": repositories.snapshot])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The user's public profile name.
      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      /// A list of repositories that the user owns.
      public var repositories: Repository {
        get {
          return Repository(snapshot: snapshot["repositories"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "repositories")
        }
      }

      public struct Repository: GraphQLSelectionSet {
        public static let possibleTypes = ["RepositoryConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nodes", type: .list(.object(Node.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nodes: [Node?]? = nil) {
          self.init(snapshot: ["__typename": "RepositoryConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [Snapshot?] in value.map { (value: Node?) -> Snapshot? in value.flatMap { (value: Node) -> Snapshot in value.snapshot } } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (snapshot["nodes"] as? [Snapshot?]).flatMap { (value: [Snapshot?]) -> [Node?] in value.map { (value: Snapshot?) -> Node? in value.flatMap { (value: Snapshot) -> Node in Node(snapshot: value) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { (value: [Node?]) -> [Snapshot?] in value.map { (value: Node?) -> Snapshot? in value.flatMap { (value: Node) -> Snapshot in value.snapshot } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes = ["Repository"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(name: String) {
            self.init(snapshot: ["__typename": "Repository", "name": name])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The name of the repository.
          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }
        }
      }
    }
  }
}

public final class SearchQuery: GraphQLQuery {
  public static let operationString =
    "query search($q: String!) {\n  search(type: REPOSITORY, query: $q, first: 15) {\n    __typename\n    edges {\n      __typename\n      node {\n        __typename\n        ...Details\n      }\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(Details.fragmentString) }

  public var q: String

  public init(q: String) {
    self.q = q
  }

  public var variables: GraphQLMap? {
    return ["q": q]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("search", arguments: ["type": "REPOSITORY", "query": GraphQLVariable("q"), "first": 15], type: .nonNull(.object(Search.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(search: Search) {
      self.init(snapshot: ["__typename": "Query", "search": search.snapshot])
    }

    /// Perform a search across resources.
    public var search: Search {
      get {
        return Search(snapshot: snapshot["search"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes = ["SearchResultItemConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("edges", type: .list(.object(Edge.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(edges: [Edge?]? = nil) {
        self.init(snapshot: ["__typename": "SearchResultItemConnection", "edges": edges.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of edges.
      public var edges: [Edge?]? {
        get {
          return (snapshot["edges"] as? [Snapshot?]).flatMap { (value: [Snapshot?]) -> [Edge?] in value.map { (value: Snapshot?) -> Edge? in value.flatMap { (value: Snapshot) -> Edge in Edge(snapshot: value) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes = ["SearchResultItemEdge"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("node", type: .object(Node.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(node: Node? = nil) {
          self.init(snapshot: ["__typename": "SearchResultItemEdge", "node": node.flatMap { (value: Node) -> Snapshot in value.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The item at the end of the edge.
        public var node: Node? {
          get {
            return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes = ["Issue", "PullRequest", "Repository", "User", "Organization", "MarketplaceListing"]

          public static let selections: [GraphQLSelection] = [
            GraphQLTypeCase(
              variants: ["Repository": AsRepository.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeIssue() -> Node {
            return Node(snapshot: ["__typename": "Issue"])
          }

          public static func makePullRequest() -> Node {
            return Node(snapshot: ["__typename": "PullRequest"])
          }

          public static func makeUser() -> Node {
            return Node(snapshot: ["__typename": "User"])
          }

          public static func makeOrganization() -> Node {
            return Node(snapshot: ["__typename": "Organization"])
          }

          public static func makeMarketplaceListing() -> Node {
            return Node(snapshot: ["__typename": "MarketplaceListing"])
          }

          public static func makeRepository(nameWithOwner: String, url: String, stargazers: AsRepository.Stargazer) -> Node {
            return Node(snapshot: ["__typename": "Repository", "nameWithOwner": nameWithOwner, "url": url, "stargazers": stargazers.snapshot])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var details: Details? {
              get {
                if !Details.possibleTypes.contains(snapshot["__typename"]! as! String) { return nil }
                return Details(snapshot: snapshot)
              }
              set {
                guard let newValue = newValue else { return }
                snapshot += newValue.snapshot
              }
            }
          }

          public var asRepository: AsRepository? {
            get {
              if !AsRepository.possibleTypes.contains(__typename) { return nil }
              return AsRepository(snapshot: snapshot)
            }
            set {
              guard let newValue = newValue else { return }
              snapshot = newValue.snapshot
            }
          }

          public struct AsRepository: GraphQLSelectionSet {
            public static let possibleTypes = ["Repository"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(nameWithOwner: String, url: String, stargazers: Stargazer) {
              self.init(snapshot: ["__typename": "Repository", "nameWithOwner": nameWithOwner, "url": url, "stargazers": stargazers.snapshot])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The repository's name with owner.
            public var nameWithOwner: String {
              get {
                return snapshot["nameWithOwner"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "nameWithOwner")
              }
            }

            /// The HTTP URL for this repository
            public var url: String {
              get {
                return snapshot["url"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "url")
              }
            }

            /// A list of users who have starred this starrable.
            public var stargazers: Stargazer {
              get {
                return Stargazer(snapshot: snapshot["stargazers"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "stargazers")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public struct Fragments {
              public var snapshot: Snapshot

              public var details: Details {
                get {
                  return Details(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }
            }

            public struct Stargazer: GraphQLSelectionSet {
              public static let possibleTypes = ["StargazerConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalCount: Int) {
                self.init(snapshot: ["__typename": "StargazerConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return snapshot["totalCount"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalCount")
                }
              }
            }
          }
        }
      }
    }
  }
}

public struct Details: GraphQLFragment {
  public static let fragmentString =
    "fragment Details on Repository {\n  __typename\n  nameWithOwner\n  url\n  stargazers {\n    __typename\n    totalCount\n  }\n}"

  public static let possibleTypes = ["Repository"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
    GraphQLField("url", type: .nonNull(.scalar(String.self))),
    GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(nameWithOwner: String, url: String, stargazers: Stargazer) {
    self.init(snapshot: ["__typename": "Repository", "nameWithOwner": nameWithOwner, "url": url, "stargazers": stargazers.snapshot])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The repository's name with owner.
  public var nameWithOwner: String {
    get {
      return snapshot["nameWithOwner"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "nameWithOwner")
    }
  }

  /// The HTTP URL for this repository
  public var url: String {
    get {
      return snapshot["url"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "url")
    }
  }

  /// A list of users who have starred this starrable.
  public var stargazers: Stargazer {
    get {
      return Stargazer(snapshot: snapshot["stargazers"]! as! Snapshot)
    }
    set {
      snapshot.updateValue(newValue.snapshot, forKey: "stargazers")
    }
  }

  public struct Stargazer: GraphQLSelectionSet {
    public static let possibleTypes = ["StargazerConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(totalCount: Int) {
      self.init(snapshot: ["__typename": "StargazerConnection", "totalCount": totalCount])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    /// Identifies the total count of items in the connection.
    public var totalCount: Int {
      get {
        return snapshot["totalCount"]! as! Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "totalCount")
      }
    }
  }
}