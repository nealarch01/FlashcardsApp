class InputValidator {
    verifyEmail(email: string): boolean {
        const regex = /^([a-zA-Z]+)([\.\-_][a-zA-Z0-9]+)*[@][a-z]+([.][a-z]+)+$/;
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
