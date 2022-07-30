import crypto from "crypto";

import Secrets from "../configs/secrets.json";

class Encoder {
    hashPassword(password: string): string {
        return crypto.createHmac("sha256", Secrets.sha256_key).update(password).digest("base64");
    }
}

export default new Encoder();
