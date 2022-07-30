import jwt from "jsonwebtoken";

import Secrets from "../configs/secrets.json";

class AuthenticationToken {
    create(user_id: number): string {
        return jwt.sign({ user_id }, Secrets.jwt_secret, { expiresIn: "1h" });
    }

    decode(authToken: string): number | undefined {
        try {
            let user_id: number;
            const decoded: any = jwt.verify(authToken, Secrets.jwt_secret);
            user_id = decoded["user_id"];
            return user_id;
        } catch (err) {
            return undefined;
        }
    }

    // Checks if a token can be decoded
    isDecodable(authToken: string): boolean {
        try {
            jwt.verify(authToken, Secrets.jwt_secret);
            return true;
        } catch (err) {
            return false;
        }
    }

    isValid(authToken: string): boolean {
        try {
            let decoded: any = jwt.verify(authToken, Secrets.jwt_secret);
            let currentTime = new Date().getTime();
            if (currentTime >= decoded.exp) {
                return false;
            }
            return true;
        } catch (err) {
            return false;
        }
    }
}

export default new AuthenticationToken();
