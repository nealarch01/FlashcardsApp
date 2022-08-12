import { Router } from "express";

    import CardSetController from "../controllers/card-set-controller";

class CardSetRouter {
    // GET 
    getCardsInSet = Router().get("/card-set/cards/:setID", CardSetController.getCardsInSet); // Passed

    // GET
    getCardsMetaData = Router().get("/card-set/metadata/:setID", CardSetController.getCardSetMetaDataFromID); // Passed

    // GET
    getCardSetsFromCreator = Router().get("/card-set/creator/:userID", CardSetController.getCardSetsFromCreator); // Passed

    // POST 
    createCardSet = Router().post("/card-set/create", CardSetController.createCardSet)

    // DELETE
    deleteCardSet = Router().delete("/card-set/delete/:setID", CardSetController.deleteCardSet)

    // PUT
    updateTitle = Router().put("/card-set/update-title/:setID", CardSetController.updateCardSetTitle)

    // PUT 
    updateDescription = Router().put("/card-set/update-description/:setID", CardSetController.updateCardSetDescription) // Passed


    // GET
    getCardSetMetaDataFromID = Router().get("/card-set/metadata/:setID", CardSetController.getCardSetMetaDataFromID)
}

export default new CardSetRouter();
