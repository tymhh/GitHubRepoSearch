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