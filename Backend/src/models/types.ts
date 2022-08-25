export interface RequestBodyError {
    status: number;
    message: string;
}

export interface ExpectedRequestBody {
    data: Array<{
        key: string;
        value_type: string;
    }>
}

// Safety instead of string literal
export enum GenericTypes {
    string = "string",
    undefined = "undefined",
    boolean = "boolean",
    number = "number"
}

export interface CardSetMetaData {
    id: number;
    creator_id: number;
    title: string;
    description: string;
    created_at: string;
    private: boolean; 
}

export interface CardData {
    id: number;
    presented: string;
    hidden: string;
}

export interface CardSetData extends CardSetMetaData {
    cards?: Array<CardData>;
}
