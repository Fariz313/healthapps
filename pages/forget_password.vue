<template>
    <div style="min-height: 100vh;">
        <div class="absolute-center">
            <div class="circle-form">
                <form>
                    <h2>Forgot Password</h2>
                    <input type="email" placeholder="Email" required>
                    <button type="submit">Send Reset Password Link</button>
                    <NuxtLink to="/login">Kembali Login? Klik Disini</NuxtLink>

                </form>
            </div>

        </div>
    </div>
</template>
<script setup lang="ts">
definePageMeta({
    layout: 'clear'
})
</script>
<style>
.absolute-center {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
}

/* Minimalist Circle Form */
.circle-form {
    width: 100%;
    max-width: 400px;
    margin: 0 auto;
    position: relative;
}

.circle-form::before {
    content: '';
    position: absolute;
    top: -50px;
    right: -50px;
    width: 200px;
    height: 200px;
    background: rgb(26, 118, 209);
    border-radius: 50%;
    z-index: -1;
    opacity: 0.1;
}

.circle-form::after {
    content: '';
    position: absolute;
    bottom: -30px;
    left: -30px;
    width: 150px;
    height: 150px;
    background: rgb(26, 118, 209);
    border-radius: 50%;
    z-index: -1;
    opacity: 0.1;
}

.circle-form form {
    background: white;
    padding: 2.5rem;
    border-radius: 20px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
}

.circle-form input {
    width: 100%;
    padding: 1rem 1.5rem;
    margin: 0.7rem 0;
    border: none;
    background: #f8f9fa;
    border-radius: 25px;
    outline: none;
    transition: background 0.3s;
}

.circle-form input:focus {
    background: #eef1f4;
}

.circle-form button {
    width: 100%;
    padding: 1rem;
    margin-top: 1.5rem;
    border: none;
    border-radius: 25px;
    background: rgb(26, 118, 209);
    color: white;
    font-weight: bold;
    cursor: pointer;
    transition: transform 0.3s;
}

.circle-form button:hover {
    transform: scale(1.02);
}
</style>