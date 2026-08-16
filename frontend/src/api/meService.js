import client from "./client";

const meService = {

    getMe: async () => {
        const response = await client.get("/me");
        return response.data;
    }

};

export default meService;