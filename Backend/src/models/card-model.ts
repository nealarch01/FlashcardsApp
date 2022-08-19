import { CardData } from "../utils/types";
import Database from "./database";

class CardModel {
    // Creates a new card and returns its insert ID.
    async createCard(presented: string, hidden: string): Promise<number> {
        let queryString = `INSERT INTO card (presented, hidden) VALUES (?, ?);`;
        let values: Array<string> = [presented, hidden];
        let queryResult: any = await Database.safeQuery(queryString, values);

        return queryResult.insertId;
    }



    // Edits the presented text of card of the given cardID.
    async editPresented(id: number, newPresented: string): Promise<boolean> {
        let queryString = `UPDATE card SET presented=? WHERE id=${id};`;
        let values: Array<string> = [newPresented];
        let queryResult: any = await Database.safeQuery(queryString, values);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }

    // Edits the hidden text of a card of the given cardID
    async editHidden(id: number, newHidden: string): Promise<boolean> {
        let queryString = `UPDATE card SET hidden=? WHERE id=${id};`;
        let values: Array<string> = [newHidden];
        let queryResult: any = await Database.safeQuery(queryString, values);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }



    // Gets a card of a certain cardID.
    async getCard(card_id: number): Promise<CardData | undefined> {
        let queryString = `SELECT * FROM card WHERE id=${card_id};`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.length === 0) {
            return undefined;
        }
        let cardData: CardData = {
            id: card_id,
            presented: queryResult[0].presented,
            hidden: queryResult[0].hidden
        };
        return cardData;
    }



    // Deletes a card of the given cardID.
    async deleteCard(card_id: number): Promise<boolean> {
        let queryString = `DELETE FROM card WHERE id=${card_id};`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }


    // Function checks if the user owns the card. 
    async checkCardOwnership(card_id: number, user_id: number): Promise<boolean> {
        let queryString = `SELECT * FROM card WHERE id=${card_id} AND user_id=${user_id};`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.length === 0) {
            return false;
        }
        return true;
    }
}

export default new CardModel();
