<template>
    <div style="min-height: 100vh;">
        <div class="absolute-center">
            <div class="circle-form">
                <form @submit.prevent="login">
                    <h2>Welcome</h2>
                    <input v-model="credentials.email" type="email" placeholder="Email" required>
                    <input v-model="credentials.password" type="password" placeholder="Password" required>
                    <button type="submit">Sign In</button>
                    <NuxtLink to="/forget_password">Lupa Password? Klik Disini</NuxtLink>
                    <br><br>
                    <NuxtLink to="/register">Belum Punya Akun? Klik Disini</NuxtLink>

                </form>
            </div>

        </div>
    </div>
</template>
<script setup lang="ts">
definePageMeta({
    layout: 'clear'
});

const { loggedIn, user, fetch: refreshSession } = useUserSession();
const credentials = reactive({
    email: '',
    password: '',
});

async function login() {
    try {
        // Send a POST request to the external API
        const response: any = await $fetch('http://127.0.0.1:8000/api/user/login', {
            method: 'POST',
            body: credentials,
            headers: {
                'Content-Type': 'application/json',
            },
        });

        // Handle the response (e.g., set session or token)
        if (response.token) {
            // Save the token or session data (e.g., in localStorage or cookies)
            localStorage.setItem('authToken', response.token);

            // Refresh the session (if using a session utility)
            await refreshSession();

            // Redirect to the home page
            await navigateTo('/');
        } else {
            alert('Login failed. Please check your credentials.');
        }
    } catch (error) {
        alert('An error occurred. Please try again.');
    }
}
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