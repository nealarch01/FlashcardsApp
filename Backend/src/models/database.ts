import mysql from "mysql2/promise";

class Database {
    private static connectionPool = mysql.createPool({
        user: "root",
        password: "12345",
        database: "FlashcardsApp",
        waitForConnections: true,
        connectionLimit: 10,
        queueLimit: 10
    });

    // Function will always return an array of data. Only use this function is query string does not contain any quotations.
    static async query(queryString: string): Promise<any | Array<any>> {
        try {
            const [rows, fields] = await this.connectionPool.query(queryString);
            return rows;
        } catch (err) {
            console.log(err);
            process.exit(1); 
        }
    }

    // This query function uses placeholders to prevent SQL injection.
    static async safeQuery(queryString: string, values: Array<any>) {
        try {
            const [rows, fields] = await this.connectionPool.query(queryString, values);
            return rows;
        } catch (err) {
            console.log(err);
            process.exit(1);
        }
    }

    // Obtain a manual connection that must be released at the end of a query
    async getConnection(): Promise<mysql.PoolConnection> {
        try {
            const connection = await Database.connectionPool.getConnection();
            return connection;
        } catch (err) {
            console.log(err);
            process.exit(1);
        }
    }
}

export default Database;
