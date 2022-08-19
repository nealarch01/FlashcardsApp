import { Request, Response } from "express";

import CardModel from "../models/card-model";

import verifyRequestBody from "../middlewares/verify-request-body";
import AuthenticationToken from "../middlewares/authentication-token";

class CardController {
    // POST
    // Creates a new flashcard.
    async createCard(req: Request, res: Response) {
        let authToken = req.headers.authorization || "";
        if (authToken === "") { // Only users can create a card
            return res.status(400).send({ 
                message: "Invalid authentication token."
            });
        }


        let presentedText = req.body["presented"];
        let hiddenText = req.body["hidden"];


        let reqError = verifyRequestBody(JSON.parse(req.body), ["presented", "hidden"], ["string", "string"]);
        if (reqError !== null) {
            return res.status(400).send({
                message: reqError.message
            });
        }


        if (presentedText.length > 50) {
            return res.status(400).send({
                message: "Presented text is too long. Must be less than 50 characters."
            });
        }


        if (hiddenText.length > 500) {
            return res.status(400).send({
                message: "Hidden text is too long. Must be less than 500 characters."
            })
        }


        let newCardID = await CardModel.createCard(presentedText, hiddenText);


        if (isNaN(newCardID) || newCardID === undefined) {
            return res.status(500).send({
                message: "There was an error creating the card. Try again."
            });
        }


        return newCardID;
    }





    // DELETE
    // Deletes the card with the given cardID.
    async deleteCard(req: Request, res: Response) {
        let authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({ 
                message: "Invalid authentication token."
            });
        }


        // Check if the cardID belongs to the user who is trying to delete it.
        const cardID = parseInt(req.body.cardID);
        if (isNaN(cardID)) {
            return res.status(400).send({
                message: "Invalid cardID provided."
            });
        }


        // Check if the user owns the card 
        if (!this.checkCardOwnership(cardID, authToken)) {
            // Forbidden
            return res.status(403).send({
                message: "You do not have permission to delete this card."
            });
        }


        const deleteStatus = await CardModel.deleteCard(cardID);
        if (deleteStatus) {
            // Inform client that deletion was successful
            return res.status(200).send({
                message: "Successfully deleted card."
            });
        }
        return res.status(500).send({
            message: "Server error; failed to delete card. Try again."
        });
    }






    // PUT
    // Updates the presented text
    async updatePresentedText(req: Request, res: Response) {            
        let authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({ 
                message: "Invalid authentication token."
            });
        }


        const cardID = parseInt(req.body.cardID);
        if (isNaN(cardID)) {
            return res.status(400).send({ 
                message: "Invalid cardID provided."
            });
        }


        const reqErr = verifyRequestBody(JSON.parse(req.body), ["presented"], ["string"]);
        if (reqErr !== null) {
            return res.status(400).send({
                message: reqErr.message
            });
        }
        const newPresentedText = req.body["presented"];


        if (newPresentedText.length > 50) {
            return res.status(400).send({ 
                message: "Presented text is too long. Must be less than 50 characters."
            });
        }


        // Check if the user owns the card.
        if (!this.checkCardOwnership(cardID, authToken)) {
            return res.status(403).send({
                message: "You do not have permission to update this card."
            });
        }


        const updateStatus = await CardModel.editPresented(cardID, newPresentedText);

        if (!updateStatus) {
            return res.status(500).send({
                message: "Could not update card text."
            });
        }


        return res.status(200).send({
            message: "Successfully updated card text."
        });
    }







    // PUT
    // Updates the hidden text
    async updateHiddenText(req: Request, res: Response) {
        let authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({ 
                message: "Invalid authentication token."
            });
        }


        const cardID = parseInt(req.body.cardID);
        if (isNaN(cardID)) {
            return res.status(400).send({ 
                message: "Invalid cardID provided."
            });
        }

        // Verify the new hidden text
        const reqErr = verifyRequestBody(JSON.parse(req.body), ["hidden"], ["string"]);
        if (reqErr !== null) {
            return res.status(400).send({
                message: reqErr.message
            });
        }

        const newHiddenText = req.body["hidden"];

        if (newHiddenText.length > 500) {
            return res.status(400).send({ 
                message: "Hidden text is too long. Must be less than 500 characters."
            });
        }

        // Now obtain the userID from the authentication token to detemrine if the user owns the card.
        if (!this.checkCardOwnership(cardID, authToken)) {
            return res.status(403).send({
                message: "You do not have permission to update this card."
            });
        }

        const updateStatus = await CardModel.editHidden(cardID, newHiddenText);

        if (!updateStatus) {
            return res.status(400).send({
                message: "Could not update card text."
            });
        }

        return res.status(200).send({
            message: "Successfully updated card text."
        });
    }





    // Private function that checks if the user owns the card with the given cardID.
    // Use for when updating
    private checkCardOwnership(cardID: number, authToken: string) {
        const userID = AuthenticationToken.decode(authToken);
        if (userID === undefined || isNaN(userID)) {
            return false;
        }
        return CardModel.checkCardOwnership(cardID, userID);
    }

}

export default new CardController();