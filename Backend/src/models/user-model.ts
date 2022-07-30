import Database from "./database";

import AuthenticationToken from "../middlewares/authentication-token";

import Encoder from "../middlewares/encoder";

class UserModel {
    async getUserID(username: string): Promise<any> {
        let queryString = `SELECT id FROM user WHERE username="${username}";`;
        let queryResult: any = await Database.query(queryString);
        return queryResult[0]; // Will return undefined if username does not exist
    }

    async searchForUser(username: string) {
        username = username.toLowerCase(); 
        let queryString = `SELECT id, username FROM user WHERE username LIKE "${username}"`;
        let queryResult = await Database.query(queryString);
        return queryResult[0];
    }

    async checkUserExists(userIdentifier: string): Promise<boolean | undefined> {
        let queryString = `SELECT * FROM user WHERE ${this.userIdentifierType(userIdentifier)}="${userIdentifier}";`;
        const queryResult: any = await Database.query(queryString);
        if (queryResult.length === 0) {
            return false;
        }
        return true;
    }

    public async changePassword(user_id: number, new_password: string) {
        let hashedPassword = Encoder.hashPassword(new_password);
        let queryString = `UPDATE user WHERE id=${user_id} SET password="${hashedPassword}";`;
        await Database.query(queryString);
    }

    public async areCredentialsValid(userIdentifier: string, password: string): Promise<boolean> {
        userIdentifier = userIdentifier.toLowerCase();
        let hashedPassword: string = Encoder.hashPassword(password);
        let queryString = `SELECT * FROM user WHERE ${this.userIdentifierType(userIdentifier)}="${userIdentifier}" AND password="${hashedPassword}";`;
        let queryResult: any = Database.query(queryString);
        if (queryResult.length === 0) {
            return false;
        }
        return true;
    }

    public async authenticateUser(userIdentifier: string, password: string): Promise<string | undefined> {
        userIdentifier = userIdentifier.toLowerCase();
        let hashedPassword: string = Encoder.hashPassword(password);
        let queryString = `SELECT id FROM user WHERE ${this.userIdentifierType(userIdentifier)}="${userIdentifier}" AND password="${hashedPassword}"`;
        const queryResult: any = await Database.query(queryString);
        if (queryResult.length === 0) {
            return undefined;
        }
        const authToken = AuthenticationToken.create(queryResult[0].id);
        return authToken;
    }

    public async createUser(username: string, password: string, email: string): Promise<string | undefined> {
        username = username.toLowerCase();
        let hashedPassword: string = Encoder.hashPassword(password);
        let queryString = `INSERT INTO user (username, password, created_at, email) VALUES("${username}", "${hashedPassword}", NOW(), "${email}");`;
        const queryResult: any = await Database.query(queryString);
        // Returns something like:
        /*
        ResultSetHeader {
            fieldCount: 0,
            affectedRows: 1,
            insertId: 2,
            info: '',
            serverStatus: 2,
            warningStatus: 0
        } */
        if (queryResult.insertId === undefined) {
            return undefined;
        }

        let authToken = AuthenticationToken.create(queryResult.insertId);
        return authToken;
    }

    public async deleteUser(user_id: number) {
        let queryString = `DELETE FROM user WHERE id=${user_id};`;
        await Database.query(queryString);
    }


    private userIdentifierType (userIdentifier: string) {
        if (userIdentifier.includes("@")) {
            return "email";
        }
        return "username";
    }

}

export default new UserModel();
