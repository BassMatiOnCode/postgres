type FieldUpdateInfoType = {
	columnName : string,	// The name of a column
	originalValue : any,		// The value as read by the client or null for insert statements
	proposedValue : any,		// The new value as requested by the client
	currentValue : any			// The value in the row at the time of execution
	}

function escapeTargetName( name: string ) : string {
	///		Removes characters not allowed for table or view names to prevent SQL injection attacks.
	///		Allowed are a-zA-z0-9_.
	let result = "" ;
	for ( let i = 0 ; i < name.length ; i ++ ) {
		let c = name[ i ];
		if ( c >= "a" && c <= "z" || c >= "A" && c <= "z" || c >= "0" && c <= "9" || c === "_"  || c === "." ) result += c;
		}
	return result;
	}

function escapeColumnName( name: string ) : string {
	///		Removes characters not allowed for column names to prevent SQL injection attacks.
	///		Allowed are a-zA-z0-9_[]
	let result = "" ;
	for ( let i = 0 ; i < name.length ; i ++ ) {
		let c = name[ i ];
		if ( c >= "a" && c <= "z" || c >= "A" && c <= "z" || c >= "0" && c <= "9" || c === "_"  || c ==="[" || c ==="]" ) result += c;
		}
	return result;
	}

function escapeColumnNames ( a : FieldUpdateInfoType [ ] ) : void {
	for ( let i = 0 ; i < a.length ; i ++ ) a[ i ].columnName = escapeColumnName( a[ i ].columnName );
	}

function executeQuery ( command : string, ...p ) : number {
	console.log( command );
	console.log( p );
	return 0 ;
	}

function genericRowUpdate( targetName : string, rowID : number, updateInfo : FieldUpdateInfoType [ ] ) {
	// Escape names
	targetName = escapeTargetName( targetName );
	escapeColumnNames( updateInfo );
	let arguments = [ ] ;
	arguments.push( "UPDATE " + escapeTargetName( targetName ) + " SET " );
	// Compile the column updates
	for ( let i = 0 ; i < updateInfo.length ; i ++ ) {
		if ( typeof updateInfo[ i ].proposedValue !== "undefined" ) {
			arguments[ 0 ] +=  ( i === 0 ? "" : "," ) + updateInfo[ i ].columnName + "=?" ;
			arguments.push( updateInfo[ i ].proposedValue );
			}	}
	// Compile the where clause row ID filter
	arguments[ 0 ] += " WHERE ID=?" ;
	arguments.push( rowID );
	// Compile the optimistic concurrency control columns
	for ( let i = 0 ; i < updateInfo.length ; i ++ ) {
		if ( typeof updateInfo[ i ].originalValue !== "undefined" ) {
			arguments[ 0 ] += " AND (old." + updateInfo[ i ].columnName + " IS NOT DISTINCT FROM ?" ;
			arguments.push(  updateInfo[ i ].originalValue );
			if ( typeof updateInfo[ i ].proposedValue !== "undefined" ) { 
				arguments[ 0 ] +=  " OR old." + updateInfo[ i ].columnName  + " IS NOT DISTINCT FROM ?" ;
			arguments.push(  updateInfo[ i ].proposedValue );
				}	}
		arguments[ 0 ] += ")" ;   // closes the parenthesis opened by AND
		}
	arguments[ 0 ] += ";" ;
	let result = executeQuery.apply( null,  arguments );
	if ( result === 0 ) { 
			
		}
	}
