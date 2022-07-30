import { Request, Response } from "express";

import AuthenticationToken from "../middlewares/authentication-token";
import verifyRequestBody from "../middlewares/verify-request-body";

import UserModel from "../models/user-model";

import InputValidator from "../utils/input-validator";

import { GenericTypes as type } from "../utils/types";

class UserController {
    public async login(req: Request, res: Response) {
        // Expects:
        // { "userIdentifier": "...", "password": "..." }
        const reqBody = JSON.parse(req.body);
        const reqBodyErr = verifyRequestBody(reqBody, ["userIdentifier", "password"], [type.string, type.string]);
        if (reqBodyErr !== null) {
            return res.status(reqBodyErr.status).send({
                message: reqBodyErr.message
            });
        }
        /*
        const reqBodyErr = verifyRequestBody_JSON(reqBody, {
            data: [
                {
                    key: "userIdentifier",
                    value_type: "string"
                },
                {
                    key: "password",
                    value_type: "string"
                }
            ]
        });

        if (reqBodyErr !== null) {
            return res.status(reqBodyErr.status).send({
                message: reqBodyErr.message
            });
        }
        */

        let userIdentifier = reqBody.userIdentifier;
        const password = reqBody.password;

        // Do regular expression matching for user and password input
        if (userIdentifier.includes("@")) { // If email
            if (!InputValidator.verifyEmail(userIdentifier)) {
                return res.status(400).send({
                    message: "Invalid email format."
                });
            }
        } else { // Not an email
            userIdentifier = userIdentifier.toLowerCase();
            if (!InputValidator.verifyUsername(userIdentifier)) {
                res.statusCode = 400;
                return res.send({
                    message: "Invalid username format."
                });
            }
        }
        if (!InputValidator.verifyPassword(password)) {
            res.statusCode = 400;
            return res.send({
                message: "Invalid password format."
            });
        }

        // Check if the user exists
        
        let userExists = await UserModel.checkUserExists(userIdentifier);
        if (!userExists) { // If the user does not exist, then return
            return res.status(404).send({
                message: "No account found"
            });
        }

        // Credentials checking 

        const authToken = await UserModel.authenticateUser(userIdentifier, password);
        if (authToken === undefined) {
            res.statusCode = 401;
            return res.send({
                message: "Incorrect credentials."
            });
        }
        res.statusCode = 200;
        return res.send({
            token: authToken
        });
    }



    public async createAccount(req: Request, res: Response) {
        const reqBody = JSON.parse(req.body);
        // Verify body 
        let reqBodyErr = verifyRequestBody(reqBody, ["username", "password", "email"], [type.string, type.string, type.string]);

        if (reqBodyErr !== null) {
            return res.status(reqBodyErr.status).send({
                message: reqBodyErr.message
            });
        }

        let username = reqBody.username.toLowerCase();
        let password = reqBody.password;
        let email = reqBody.email;

        if (!InputValidator.verifyUsername(username)) {
            res.statusCode = 400;
            return res.send({
                message: "Invalid username format."
            });
        }
        // Verify password
        if (!InputValidator.verifyPassword(password)) {
            res.statusCode = 400;
            return res.send({
                message: "Invalid password format."
            });
        }
        // Verify email
        if (!InputValidator.verifyEmail(email)) {
            res.statusCode = 400;
            return res.send({
                message: "Invalid email format."
            });
        }
        // Check if username or email already exists in the database
        if (await UserModel.checkUserExists(username)) {
            res.statusCode = 406; // Invalid
            return res.send({
                message: "Username taken"
            });
        }
        if (await UserModel.checkUserExists(email)) {
            res.statusCode = 406;
            return res.send({
                message: "An account with this email has already been registered"
            });
        }
        let newUserAuthToken = await UserModel.createUser(username, password, email);

        if (newUserAuthToken === undefined) {
            res.statusCode = 500;
            return res.send({
                message: "Internal server error. Could not create account. Try again"
            });
        }
        res.statusCode = 201;
        return res.send({
            token: newUserAuthToken
        });
    }



    public async deleteUser(req: Request, res: Response) {
        const reqBody = JSON.parse(req.body);
        const reqBodyErr = verifyRequestBody(reqBody, ["token"], [type.string]);
        if (reqBodyErr !== null) {
            return res.status(reqBodyErr.status).send({
                message: reqBodyErr.message
            });
        }
        const authToken = reqBody.token;
        if (!AuthenticationToken.isValid(authToken)) {
            res.statusCode = 400;
            return res.send({
                message: "Invalid authentication token."
            });
        }
        const decodedUserID = AuthenticationToken.decode(authToken)!;
        await UserModel.deleteUser(decodedUserID);
        res.statusCode = 200;
        return res.send({
            message: "Account deleted."
        });
    }



    public async checkTokenActive(req: Request, res: Response) {
        const reqBody = JSON.parse(req.body);
        const reqBodyErr = verifyRequestBody(reqBody, ["token"], [type.string]);
        if (reqBodyErr !== null) {
            return res.status(reqBodyErr.status).send({
                message: reqBodyErr.message
            });
        }

        const authToken = reqBody.token;
        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(406).send({
                active: false,
                message: "Token is expired"
            });
        }
        return res.status(200).send({
            active: true,
            message: "Token is active"
        });
    }



    public async renewToken(req: Request, res: Response) {
        const reqBody = JSON.parse(req.body);
        const reqBodyErr = verifyRequestBody(reqBody, ["token"], [type.string]);
        if (reqBodyErr !== null) {
            return res.status(reqBodyErr.status).send({
                message: reqBodyErr.message
            });
        }

        const oldToken = reqBody.token;
        const decodedUserID = AuthenticationToken.decode(oldToken);

        if (decodedUserID === undefined) {
            res.statusCode = 401;
            return res.status(401).send({
                message: "Token is not valid."
            });
        }

        const newAuthToken = AuthenticationToken.create(decodedUserID);
        return res.status(200).send({
            token: newAuthToken
        });
    }
}


export default new UserController();
