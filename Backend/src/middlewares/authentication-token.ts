import jwt from "jsonwebtoken";

import Secrets from "../configs/secrets.json";

class AuthenticationToken {
    private removeBearer(authToken: string): string {
        if (authToken.startsWith("Bearer ")) {
            return authToken.replace("Bearer ", "");
        }
        return authToken;
    }
    create(user_id: number): string {
        // For testing purposes, we will set the expiration to 1 day
        // Change this later
        return jwt.sign({ user_id }, Secrets.jwt_secret, { expiresIn: "1d" });
    }

    decode(authToken: string): number | undefined {
        authToken = this.removeBearer(authToken);
        try {
            let user_id: number;
            const decoded: any = jwt.verify(authToken, Secrets.jwt_secret);
            user_id = decoded["user_id"];
            return user_id;
        } catch (err) {
            return undefined;
        }
    }

    // Method that determines if a json web token has expired
    isExpired(authToken: string): boolean {
        authToken = this.removeBearer(authToken);
        try {
            let decoded: any = jwt.verify(authToken, Secrets.jwt_secret);
            let currentTime = new Date().getTime() / 1000;
            if (currentTime >= decoded.exp) {
                return true;
            }
            return false;
        } catch (err) {
            return true;
        }
    }

    // Checks if a token can be decoded
    isDecodable(authToken: string): boolean {
        authToken = this.removeBearer(authToken);
        try {
            jwt.verify(authToken, Secrets.jwt_secret);
            return true;
        } catch (err) {
            return false;
        }
    }

    isValid(authToken: string): boolean {
        authToken = this.removeBearer(authToken);
        try {
            let decoded: any = jwt.verify(authToken, Secrets.jwt_secret);
            if (this.isExpired(authToken)) {
                return false;
            }
            return true;
        } catch (err) {
            return false;
        }
    }
}

export default new AuthenticationToken();
