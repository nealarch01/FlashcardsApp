interface RequestBodyError {
    status: number;
    message: string;
}

interface ExpectedRequestBody {
    data: Array<{
        key: string;
        value_type: string;
    }>;
}

// Double array implementation
function verifyRequestBody(body: any, keys: Array<string>, expectedValueType: Array<string>): RequestBodyError | null {
    if (body === undefined) {
        return {
            status: 400,
            message: "Error: Request body was not provided."
        }
    }
    for (let i = 0; i < keys.length; i++) {
        let key = keys[i];
        if (typeof body[key] !== expectedValueType[i]) {
            return {
                status: 400,
                message: `Error: Value of \`${key}\` is invalid.`
            }
        }
    }

    return null;
}

// JSON Version implementation
function verifyRequestBody_JSON(body: any, expected: ExpectedRequestBody): RequestBodyError | null {
    if (body === undefined) {
        return {
            status: 400,
            message: `Error: Request body was not provided.`
        }
    }

    for (let i = 0; i < expected.data.length; i++) {
        let keyName = expected.data[i].key;
        let valueType = expected.data[i].value_type;
        if (typeof body[keyName] !== valueType) {
            return {
                status: 400,
                message: `Error: Value of \`${keyName}\` is invalid.`
            }
        }
    }

    return null;
}

export default verifyRequestBody;
