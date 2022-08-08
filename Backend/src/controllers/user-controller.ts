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
                return res.status(400).send({
                    message: "Invalid username format."
                });
            }
        }
        if (!InputValidator.verifyPassword(password)) {
            return res.status(400).send({
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

        return res.status(200).send({
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
            return res.status(400).send({
                message: "Invalid username format."
            });
        }
        // Verify password
        if (!InputValidator.verifyPassword(password)) {
            return res.status(400).send({
                message: "Invalid password format."
            });
        }
        // Verify email
        if (!InputValidator.verifyEmail(email)) {
            return res.status(400).send({
                message: "Invalid email format."
            });
        }
        // Check if username or email already exists in the database
        if (await UserModel.checkUserExists(username)) {
            return res.status(406).send({
                message: "Username taken"
            });
        }
        if (await UserModel.checkUserExists(email)) {
            return res.status(406).send({
                message: "An account with this email has already been registered."
            });
        }
        let newUserAuthToken = await UserModel.createUser(username, password, email);

        return res.status(201).send({
            token: newUserAuthToken
        });
    }



    public async deleteUser(req: Request, res: Response) {
        const authToken = req.headers.authorization;
        if (authToken === undefined) {
            res.statusCode = 401;
            return res.status(401).send({
                message: "No authentication token provided"
            });
        }
        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(400).send({
                message: "Invalid authentication token."
            });
        }
        const decodedUserID = AuthenticationToken.decode(authToken)!;
        await UserModel.deleteUser(decodedUserID);
        return res.status(200).send({
            message: "Account deleted."
        });
    }
}


export default new UserController();
