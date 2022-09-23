function escapeTargetName(name) {
    ///		Removes characters not allowed for table or view names to prevent SQL injection attacks.
    ///		Allowed are a-zA-z0-9_.
    var result = "";
    for (var i = 0; i < name.length; i++) {
        var c = name[i];
        if (c >= "a" && c <= "z" || c >= "A" && c <= "z" || c >= "0" && c <= "9" || c === "_" || c === ".")
            result += c;
    }
    return result;
}
function escapeColumnName(name) {
    ///		Removes characters not allowed for column names to prevent SQL injection attacks.
    ///		Allowed are a-zA-z0-9_[]
    var result = "";
    for (var i = 0; i < name.length; i++) {
        var c = name[i];
        if (c >= "a" && c <= "z" || c >= "A" && c <= "z" || c >= "0" && c <= "9" || c === "_" || c === "[" || c === "]")
            result += c;
    }
    return result;
}
function escapeColumnNames(a) {
    for (var i = 0; i < a.length; i++)
        a[i].columnName = escapeColumnName(a[i].columnName);
}
function executeQuery(command) {
    var p = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        p[_i - 1] = arguments[_i];
    }
    console.log(command);
    console.log(p);
    return 0;
}
function genericRowUpdate(targetName, rowID, updateInfo) {
    // Escape names
    targetName = escapeTargetName(targetName);
    escapeColumnNames(updateInfo);
    var arguments = [];
    arguments.push("UPDATE " + escapeTargetName(targetName) + " SET ");
    // Compile the column updates
    for (var i = 0; i < updateInfo.length; i++) {
        if (typeof updateInfo[i].proposedValue !== "undefined") {
            arguments[0] += (i === 0 ? "" : ",") + updateInfo[i].columnName + "=?";
            arguments.push(updateInfo[i].proposedValue);
        }
    }
    // Compile the where clause row ID filter
    arguments[0] += " WHERE ID=?";
    arguments.push(rowID);
    // Compile the optimistic concurrency control columns
    for (var i = 0; i < updateInfo.length; i++) {
        if (typeof updateInfo[i].originalValue !== "undefined") {
            arguments[0] += " AND (old." + updateInfo[i].columnName + " IS NOT DISTINCT FROM ?";
            arguments.push(updateInfo[i].originalValue);
            if (typeof updateInfo[i].proposedValue !== "undefined") {
                arguments[0] += " OR old." + updateInfo[i].columnName + " IS NOT DISTINCT FROM ?";
                arguments.push(updateInfo[i].proposedValue);
            }
        }
        arguments[0] += ")"; // closes the parenthesis opened by AND
    }
    arguments[0] += ";";
    var result = executeQuery.apply(null, arguments);
    if (result === 0) {
    }
}
//# sourceMappingURL=test.js.map