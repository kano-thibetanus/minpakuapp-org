public extension String {
    /// Realm用の文字列
    var realmEscaped: String {
        let reps = [
            "\\": "\\\\",
            "'": "\\'",
            "　": " "
        ]
        var ret = self
        for rep in reps {
            ret = replacingOccurrences(of: rep.0, with: rep.1)
        }
        return ret
    }
}
