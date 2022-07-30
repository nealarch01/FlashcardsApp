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

