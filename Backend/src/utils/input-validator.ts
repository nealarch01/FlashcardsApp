class InputValidator {
    verifyEmail(email: string): boolean {
        // Regex for email address (RFC 5322)
        const regex = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/g;
        return regex.test(email);
    }

    // Returns false if the username does not pass regex or is too long / short
    verifyUsername(username: string): boolean {
        if (username.length < 4) {
            return false;
        }

        if (username.length > 20) {
            return false;
        }

        const regex = /^[0-9]*[a-zA-Z]([0-9a-zA-Z]|([._\-][0-9a-zA-Z]))*$/g;
        return regex.test(username);
    }

    verifyPassword(password: string): boolean {
        // Password too short
        if (password.length < 6) {
            return false;
        }
    
        // Limit password to a length of 32
        if (password.length > 32) {
            return false; 
        }

        const regex = /^[0-9a-zA-Z!@#\$%&\*_\-;.\/\{\}\[\]~()]+$/g; // Omit ' and " characters from a password
        return regex.test(password);
    }

}

export default new InputValidator();
