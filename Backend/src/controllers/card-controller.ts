import { Request, Response } from "express";

import CardModel from "../models/card-model";

import verifyRequestBody from "../middlewares/verify-request-body";
import AuthenticationToken from "../middlewares/authentication-token";

class CardController {
    readonly presentedMax: number = 50;
    readonly hiddenMax: number = 500;
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


        if (presentedText.length > this.presentedMax) {
            return res.status(400).send({
                message: "Presented text is too long. Must be less than 50 characters."
            });
        }


        if (hiddenText.length > this.hiddenMax) {
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


        return res.status(201).send({
            message: "Successfully created new card.",
            cardID: newCardID
        });
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



    // GET 
    // Returns the card of the given cardID
    async getCard(req: Request, res: Response) {
        const cardID = parseInt(req.params.cardID);
        if (isNaN(cardID)) {
            return res.status(400).send({
                message: "Invalid cardID provided."
            });
        }

        const card = await CardModel.getCard(cardID);
        if (card === undefined) {
            return res.status(404).send({
                message: "Could not obtain card."
            });
        }

        const authToken = req.headers.authorization || "";
        if (authToken === "" ) {
            return res.status(400).send({
                message: "Token was not provided."
            });
        }
        if (!await this.checkCardOwnership(cardID, authToken)) {
            // Forbidden
            return res.status(403).send({
                message: "You do not have permission to view this card."
            });
        }

        // Then, call the getCard function in the CardModel class to obtain card.
        let cardData = CardModel.getCard(cardID);
        if (cardData === undefined) {
            return res.status(404).send({
                message: "Could not obtain card."
            });
        }

        
        return res.status(200).send({
            cardData
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


        if (newPresentedText.length > this.presentedMax) {
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

        if (newHiddenText.length > this.hiddenMax) {
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


    // PUT 
    // Updates both the presented and hidden text of the card.
    async updateCardText(req: Request, res: Response) {
        let authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({ 
                message: "Invalid authentication token."
            });
        }
        
        const cardID = parseInt(req.params.cardID);
        if (isNaN(cardID)) {
            return res.status(400).send({ 
                message: "Invalid cardID provided."
            });
        }

        if (!this.checkCardOwnership(cardID, authToken)) {
            return res.status(403).send({
                message: "You do not have permission to update this card."
            });
        }


        const reqErr = verifyRequestBody(JSON.parse(req.body), ["presented", "hidden"], ["string", "string"]);
        if (reqErr !== null) {
            return res.status(400).send({
                message: reqErr.message
            });
        }
        const newPresentedText = req.body["presented"];
        const newHiddenText = req.body["hidden"];

        if (newPresentedText.length > this.presentedMax) {
            return res.status(400).send({ 
                message: "Presented text is too long. Must be less than 50 characters."
            });
        }

        if (newHiddenText.length > this.hiddenMax) {
            return res.status(400).send({ 
                message: "Hidden text is too long. Must be less than 500 characters."
            });
        }

        // Once we have verified that the presented and hidden text is valid, then update the database.
        const updateStatus_presented = await CardModel.editPresented(cardID, newPresentedText);
        const updateStatus_hidden = await CardModel.editHidden(cardID, newHiddenText);

        if (!updateStatus_presented || !updateStatus_hidden) {
            return res.status(500).send({
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
