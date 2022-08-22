import { Request, Response } from "express";

import AuthenticationToken from "../middlewares/authentication-token";
import verifyRequestBody from "../middlewares/verify-request-body";

import { CardSetMetaData, GenericTypes as types } from "../models/types";

import CardSetModel from "../models/card-set-model";

class CardSetController {
    // POST
    // Create a new card set
    async createCardSet(req: Request, res: Response) {
        const authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({
                message: "Authentication was not provided"
            });
        }
        const reqBody = JSON.parse(req.body);
        const reqBodyErr = verifyRequestBody(reqBody, ["title", "description"], [types.string, types.string]);
        if (reqBodyErr !== null) {
            return res.status(400).send({
                message: "Invalid title or description format."
            });
        }
        const user_id = AuthenticationToken.decode(authToken);
        const title = reqBody.title;
        const description = reqBody.description;

        let newCardSetID = await CardSetModel.createCardSet(user_id!, title, description);
        return res.status(201).send({
            new_resource_id: newCardSetID,
            message: "Card set created successfully.",
        });
    }









    // DELETE
    // Delete a card set
    async deleteCardSet(req: Request, res: Response) {
        const authToken = req.headers.authorization || "";
        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(400).send({
                message: "Invalid authorization token."
            });
        }

        const setID = parseInt(req.params.setID);
        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID format."
            });
        }

        // Check if the user owns the set
        const user_id = AuthenticationToken.decode(authToken);
        const ownedSets = await CardSetModel.getCardSetsFromCreator(user_id!);
        if (!ownedSets.some(set => set.id === setID)) {
            return res.status(401).send({
                message: "You do not own this set."
            });
        }

        let deleteStatus = await CardSetModel.deleteCardSet(setID);

        if (deleteStatus === true) {
            return res.status(200).send({
                message: "Card set deleted successfully."
            });
        }
        return res.status(500).send({
            message: "Card set could not be deleted."
        });
    }








    // PUT
    // Updates the title of a card set
    async updateCardSetTitle(req: Request, res: Response) {
        // Expects: { "title": "..." }
        let authToken = req.headers.authorization || ""
        if (authToken === "") {
            return res.status(400).send({
                message: "Authentication token was not provided."
            });
        }

        authToken = authToken.replace("Bearer ", "");

        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(400).send({
                message: "Invalid authentication token."
            });
        }

        const setID = parseInt(req.params.setID);

        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID provided."
            });
        }

        // Check if user owns the set
        const user_id = AuthenticationToken.decode(authToken);

        // console.log(user_id);
        // console.log(setID);
        
        if (!await CardSetModel.checkUserOwnership(setID, user_id!)) {
            return res.status(400).send({
                message: "You do not own this set."
            });
        }

        const newTitle = JSON.parse(req.body).title;

        if (newTitle === undefined) {
            return res.status(400).send({
                message: "`Title` was not provided."
            });
        }

        if (newTitle.length > 32) {
            return res.status(400).send({
                message: "Title is too long. Must be less than 64 characters."
            });
        }

        let updateStatus = await CardSetModel.updateTitle(setID, newTitle);
        if (updateStatus === false) {
            return res.status(500).send({
                message: "Could not update title."
            });
        }
        return res.status(200).send({
            message: "Successfully updated title."
        });
    }










    // PUT
    // Updates the description of a card set
    async updateCardSetDescription(req: Request, res: Response) {
        const authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({
                message: "Authentication token was not provided."
            });
        }

        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(400).send({
                message: "Invalid authentication token."
            });
        }

        const setID = parseInt(req.params.setID);
        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID format."
            });
        }

        // Check if user owns the set
        const user_id = AuthenticationToken.decode(authToken);
        if (!await CardSetModel.checkUserOwnership(user_id!, setID)) {
            return res.status(400).send({
                message: "You do not own this set."
            });
        }

        const newDescription = req.body.description;
        if (newDescription === undefined) {
            return res.status(400).send({
                message: "Invalid description provided."
            });
        }

        if (newDescription.length > 300) {
            return res.status(400).send({
                message: "Description is too long. Must be less than 300 characters."
            });
        }

        let updateStatus = await CardSetModel.updateDescription(setID, newDescription);
        if (updateStatus === false) {
            return res.status(500).send({
                message: "Could not update description."
            });
        }
        return res.status(200).send({
            message: "Successfully updated description."
        });
    }










    // GET 
    // Get the flashcards in a set
    async getCardsInSet(req: Request, res: Response) {
        // console.log(req.params.setID);
        const setID = parseInt(req.params.setID);

        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID."
            });
        }

        if (await CardSetModel.isCardSetPrivate(setID)) {
            const authToken = req.headers.authorization || "";
            if (!AuthenticationToken.isValid(authToken)) {
                return res.status(401).send({
                    message: "You do not have permission to view this set."
                });
            }
            const user_id = AuthenticationToken.decode(authToken);
            if (!await CardSetModel.checkUserOwnership(user_id!, setID)) {
                return res.status(401).send({
                    message: "You do not have permission to view this set."
                });
            }
        }

        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID format."
            });
        }
        const cards = await CardSetModel.getCardsInSet(setID);
        return res.status(200).send(cards);
    }








    // GET
    async getCardSetsFromCreator(req: Request, res: Response) {
        const userID = parseInt(req.params.userID);
        // console.log(userID);
        if (isNaN(userID)) {
            return res.status(400).send({
                message: "Invalid userID."
            });
        }

        const allCardSets = await CardSetModel.getCardSetsFromCreator(userID);

        const authToken = req.headers.authorization || "";
        
        const receiverUserID = AuthenticationToken.decode(authToken);

        // Do not return private sets if the requester is not the creator
        if (receiverUserID === undefined || receiverUserID !== userID) {
            let publicCardSets = allCardSets.filter((set: CardSetMetaData) => set.private === false);
            return res.status(200).send(publicCardSets);
        }

        return res.status(200).send(allCardSets);
    }


    // GET
    async getCardSetDataFromID(req: Request, res: Response) {
        const setID = parseInt(req.params.setID);
        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID."
            });
        }

        const cardSet = await CardSetModel.getCardSetDataFromID(setID);
        if (cardSet === undefined) {
            return res.status(500).send({
                message: "Internal server error. Could not get card set."
            });                     
        }

        // If the card set is private, check if the user is the creator
        if (cardSet.private === true) {
            const authToken = req.headers.authorization || "";

            if (!AuthenticationToken.isValid(authToken)) {
                return res.status(400).send({
                    message: "Invalid authentication token."
                });
            }

            const user_id = AuthenticationToken.decode(authToken);
            
            if (cardSet.creator_id !== user_id) {
                return res.status(401).send({
                    message: "You do not have permission to view this set."
                });
            }
        }
        return res.status(200).send(cardSet);
    }

    // GET 
    async getOwnedSets(req: Request, res: Response) {
        const authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({
                message: "Authentication token was not provided."
            });
        }

        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(400).send({
                message: "Invalid authentication token."
            });
        }

        const user_id = AuthenticationToken.decode(authToken);

        const ownedSets = await CardSetModel.getCardSetsFromCreator(user_id!);

        return res.status(200).send(ownedSets);
    }





    // GET
    async getCardSetMetaDataFromID(req: Request, res: Response) {
        const setID = parseInt(req.params.setID);
        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID format."
            });
        }

        const isPrivate = await CardSetModel.isCardSetPrivate(setID);

        if (isPrivate) {
            // Check if the user has access to the set
            const authToken = req.headers.authorization || "";
            if (!AuthenticationToken.isValid(authToken)) {
                return res.status(401).send({
                    message: "You cannot view this set."
                });
            }
        }

        // If not private or the user has access, get the set metadata

        const cardSet = await CardSetModel.getCardSetMetaDataFromID(setID);

        if (cardSet === undefined) {
            return res.status(404).send({
                message: "Card set does not exist."
            });
        }

        return res.status(200).send(cardSet);
    }





    // PUT
    async makePrivate(req: Request, res: Response) {
        let authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({
                message: "Authentication token was not provided."
            });
        }
        let setID = parseInt(req.params.setID);
        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid SetID."
            });
        }

        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(400).send({
                message: "Invalid authentication token."
            });
        }

        const user_id = AuthenticationToken.decode(authToken);
        if (!await CardSetModel.checkUserOwnership(user_id!, setID)) {
            return res.status(401).send({
                message: "You do not own this set."
            });
        }
        const updateStatus = await CardSetModel.makePrivate(setID);
        if (updateStatus === false) {
            return res.status(500).send({
                message: "Could not make set private. Try again."
            });
        }

        return res.status(200).send({
            message: "Successfully updated card set!"
        });
    }







    // PUT
    async makePublic(req: Request, res: Response) {
        let authToken = req.headers.authorization || "";
        if (authToken === "") {
            return res.status(400).send({
                message: "Authentication token was not provided."
            });
        }
        let setID = parseInt(req.params.setID);
        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID"
            });
        }

        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(400).send({
                message: "Invalid authentication token."
            });
        }

        const user_id = AuthenticationToken.decode(authToken);
        if (!await CardSetModel.checkUserOwnership(user_id!, setID)) {
            return res.status(401).send({
                message: "You do not own this set."
            });
        }
        const updateStatus = await CardSetModel.makePublic(setID);
        if (updateStatus === false) {
            return res.status(500).send({
                message: "Could not make set public. Try again."
            });
        }
    }




}


export default new CardSetController();
