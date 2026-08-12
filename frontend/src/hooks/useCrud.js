import { useState } from "react";

export function useCrud({
    service,
    initialForm,
    buildPayload
}) {

    const [form, setForm] = useState(initialForm);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);


    // =====================================================
    // SUBMIT
    // =====================================================

    const handleSubmit = async (formData) => {

        console.log(
            "useCrud - handleSubmit:",
            formData
        );

        const payload = buildPayload(formData);

        console.log(
            "Final payload:",
            payload
        );

        if (!payload) {
            console.error(
                "Payload building failed"
            );

            return false;
        }

        setLoading(true);
        setError(null);

        try {

            if (formData.id) {

                console.log(
                    "UPDATING:",
                    formData.id
                );

                await service.update(
                    formData.id,
                    payload
                );

            } else {

                console.log(
                    "CREATING new record"
                );

                await service.create(
                    payload
                );
            }

            console.log(
                "CRUD operation successful"
            );

            resetForm();

            return true;

        } catch (err) {

            console.error(
                "Submit error:",
                err
            );

            setError(err);

            return false;

        } finally {

            setLoading(false);

        }
    };


    // =====================================================
    // DELETE
    // =====================================================

    const handleDelete = async (id) => {

        if (
            !window.confirm(
                "Are you sure you want to delete this item?"
            )
        ) {
            return false;
        }

        setLoading(true);
        setError(null);

        try {

            await service.delete(id);

            console.log(
                "Delete successful"
            );

            return true;

        } catch (err) {

            console.error(
                "Delete error:",
                err
            );

            setError(err);

            alert(
                `Error deleting: ${err.response?.data?.message ||
                err.message
                }`
            );

            return false;

        } finally {

            setLoading(false);

        }
    };


    // =====================================================
    // EDIT
    // =====================================================

    const handleEdit = (item, mapToForm) => {

        setForm(
            mapToForm(item)
        );

    };


    // =====================================================
    // RESET
    // =====================================================

    const resetForm = () => {

        setForm({
            ...initialForm
        });

    };


    return {
        form,
        setForm,
        loading,
        error,
        handleSubmit,
        handleEdit,
        handleDelete,
        resetForm
    };
}