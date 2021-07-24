export const uploadSlate = async () => {
    const url = 'https://uploads.slate.host/api/public/bafybeieh4u6tkbavz33xu2h3r4boapbnedhutrgudsr23llef2f6wdammy'; // collection ID

    let file = e.target.files[0];
    let data = new FormData();

    data.append("data", file);

    const response = await fetch(url, {
        method: 'POST',
        headers: {
            Authorization: 'Basic SLA450bbe9a-8d01-4d3f-b32a-93b4e3cdb6f1TE', // API key  
        },
        body: data
    });

    return response;
}
