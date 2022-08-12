import Database from "./database";

import { CardSetMetaData, CardData } from "../utils/types";

class CardSetModel {
    // Return the insert id of the newly created card set
    async createCardSet(creator_id: number, title: string, description: string): Promise<number> {
        let queryString = `INSERT INTO card_set (creator_id, title, description, created_at) VALUES (?, ?, ?, ?, NOW());`;
        let values: Array<any> = [creator_id, title, description];
        let queryResult: any = await Database.safeQuery(queryString, values);
        return queryResult.insertId;
    }


    async deleteCardSet(card_set_id: number): Promise<boolean> {
        let queryString = `DELETE FROM card_set WHERE id=${card_set_id};`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }

    async updateTitle(card_set_id: number, newTitle: string): Promise<boolean> {
        let queryString = `UPDATE card_set SET title = ? WHERE id = ${card_set_id};`;
        let values: Array<string> = [newTitle];
        let queryResult: any = await Database.safeQuery(queryString, values);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }

    async updateDescription(card_set_id: number, newDescription: string): Promise<boolean> {
        let queryString = `UPDATE card_set SET description = ? WHERE id = ${card_set_id};`;
        let values: Array<string> = [newDescription];
        let queryResult: any = await Database.safeQuery(queryString, values);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }

    async getCardSetMetaDataFromID(card_set_id: number): Promise<CardSetMetaData | undefined> {
        let queryString = `SELECT * FROM card_set WHERE id=${card_set_id};`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.length === 0) {
            return undefined;
        }
        let cardSetMetadata: CardSetMetaData = {
            id: queryResult[0].id,
            creator_id: queryResult[0].creator_id,
            title: queryResult[0].title,
            description: queryResult[0].description,
            created_at: queryResult[0].created_at,
            private: queryResult[0].private === 1 ? true : false
        };
        return cardSetMetadata;
    }

    async getCardSetsFromCreator(creator_id: number): Promise<Array<CardSetMetaData>> {
        let queryString = `SELECT * FROM card_set WHERE creator_id=${creator_id};`;
        let queryResult: any = await Database.query(queryString);
        let cardSetMetadata: Array<CardSetMetaData> = [];
        for (let i = 0; i < queryResult.length; i++) {
            let cardSet: CardSetMetaData = {
                id: queryResult[i].id,
                creator_id: creator_id,
                title: queryResult[i].title,
                description: queryResult[i].description,
                created_at: queryResult[i].created_at,
                private: queryResult[i].private === 1 ? true : false
            };
            cardSetMetadata.push(cardSet);
        }
        return cardSetMetadata;
    }

    async searchCardSetFromTitle(title: string): Promise<CardSetMetaData | undefined> {
        let queryString = `SELECT * FROM card_set WHERE title LIKE ?;`;
        let values: Array<string> = [title];
        let queryResult: any = await Database.safeQuery(queryString, values);
        if (queryResult.length === 0) {
            return undefined;
        }
        let cardSetMetadata: CardSetMetaData = {
            id: queryResult[0].id,
            creator_id: queryResult[0].creator_id,
            title: queryResult[0].title,
            description: queryResult[0].description,
            created_at: queryResult[0].created_at,
            private: queryResult[0].private === 1 ? true : false
        };
        return cardSetMetadata;
    }

    async transferCardSetOwnership(creator_id: number, card_set_id: number, new_creator_id: number): Promise<boolean> {
        let queryString = `UPDATE card_set SET creator_id=${new_creator_id} WHERE id=${card_set_id};`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }

    async addCardToSet(card_set_id: number, card_id: number): Promise<boolean> {
        let queryString = `INSERT INTO set_data (set_id, card_id) VALUES (${card_set_id}, ${card_id}));`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }

    async removeCardFromSet(card_set_id: number, card_id: number): Promise<boolean> {
        let queryString = `DELETE FROM set_data WHERE set_id = ${card_set_id} AND card_id = ${card_id};`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.affectedRows === 0) {
            return false;
        }
        return true;
    }


    async getCardsInSet(set_id: number): Promise<Array<CardData>> {
        let queryString = `SELECT * FROM card WHERE id IN (SELECT card_id from set_data WHERE set_id=${set_id});`;
        let queryResult: any = await Database.query(queryString);
        let cards: Array<CardData> = [];
        for (let i = 0; i < queryResult.length; i++) {
            let cardData: CardData = {
                id: queryResult[i].id,
                presented: queryResult[i].presented,
                hidden: queryResult[i].hidden
            };
            cards.push(cardData);
        }
        return cards;
    }

    async checkUserOwnership(set_id: number, user_id: number): Promise<boolean> {
        let queryString = `SELECT * FROM card_set WHERE id=${set_id} AND creator_id=${user_id};`;
        let queryResult: any = await Database.query(queryString);
        if (queryResult.length === 0) {
            return false;
        }
        return true;
    }

    async isCardSetPrivate(card_set_id: number): Promise<boolean> {
        let queryString = `SELECT * FROM card_set WHERE id=${card_set_id} AND private=1;`;
        const queryResult: any = await Database.query(queryString);
        if (queryResult.length === 0) {
            return false;
        }
        return true;
    }
}

export default new CardSetModel();
