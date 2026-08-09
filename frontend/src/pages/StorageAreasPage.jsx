// frontend/src/pages/StorageAreasPage.jsx
// const storageAreaFieldConfig = [
//     { name: "name", label: "Storage Area Name", required: true },
//     { name: "facilityId", label: "Facility", type: "select", required: true, options: [] },
//     { name: "zoneCode", label: "Zone Code", required: true },
//     { name: "shelf", label: "Shelf", required: false },
//     { name: "container", label: "Container", required: false },
//     { name: "capacity", label: "Capacity (kg)", type: "number", required: true },
//     { name: "isActive", label: "Active", type: "checkbox", required: false, defaultValue: true },
// ];

// const StorageAreasPage = () => {
//     const fetchExtraData = async () => {
//         const facilities = await facilityService.getAll();
//         return {
//             facilityId: facilities.data.map(f => ({ value: f.id, label: f.name }))
//         };
//     };

//     return (
//         <GenericEntityPage
//             entityName="Storage Areas"
//             service={storageAreaService}
//             fieldConfig={storageAreaFieldConfig}
//             displayColumns={[
//                 { key: "name", label: "Name" },
//                 { key: "zoneCode", label: "Zone" },
//                 { key: "capacity", label: "Capacity" },
//                 { key: "isActive", label: "Active" },
//             ]}
//             fetchExtraData={fetchExtraData}
//         />
//     );
// };