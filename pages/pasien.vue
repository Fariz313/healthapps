<template>
  <div class="container-fluid mt-5">
    <div class="d-flex justify-content-between">
      <h1>Data Pasien</h1>
      <div>
        <!-- Button trigger modal -->
        <button type="button" class="btn btn-primary" @click="resetModal" data-bs-toggle="modal"
          data-bs-target="#exampleModal">
          Tambah Data Pasien
        </button>

        <!-- Modal -->
        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-xl">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">
                  {{ isEditing ? 'Edit Data Pasien' : 'Tambah Data Pasien' }}
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <form @submit.prevent="saveData">
                  <label for="name" class="form-label">Jenis Pasien</label>
                  <select v-model="typePasien"  class="select-form" name="type" id="type">
                    <option value="" selected disabled> pilih jenis pasien</option>
                    <option value="general"> Umum</option>
                    <option value="child"> Anak</option>
                    <option value="pregnant"> Ibu Hamil</option>
                  </select>
                  <!-- Baris 1: Nama, Email -->
                  <div class="row mb-3">
                    <div class="col-md-4">
                      <label for="name" class="form-label">Nama Lengkap</label>
                      <input type="text" class="form-control" id="name" name="name" :value="currentData?.name"
                        placeholder="Masukkan nama lengkap">
                    </div>
                    <div class="col-md-4">
                      <label for="email" class="form-label">Email</label>
                      <input type="email" class="form-control" id="email" name="email" :value="currentData?.email"
                        placeholder="Masukkan email">
                    </div>
                  </div>

                  <!-- Baris 2: Tanggal Lahir, Nama Ibu, Nama Ayah -->
                  <div class="row mb-3">
                    <div class="col-md-4">
                      <label for="birth_date" class="form-label">Tanggal Lahir</label>
                      <input type="date" class="form-control" id="birth_date" name="birth_date"
                        :value="currentData?.birth_date">
                    </div>
                    <div class="col-md-4">
                      <label for="mother_name" class="form-label">Nama Ibu</label>
                      <input type="text" class="form-control" id="mother_name" name="mother_name"
                        :value="currentData?.mother_name" placeholder="Masukkan nama ibu">
                    </div>
                    <div class="col-md-4">
                      <label for="father_name" class="form-label">Nama Ayah</label>
                      <input type="text" class="form-control" id="father_name" name="father_name"
                        :value="currentData?.father_name" placeholder="Masukkan nama ayah">
                    </div>
                  </div>

                  <!-- Baris 3: Telepon Orang Tua, Alamat, Telepon -->
                  <div class="row mb-3">
                    <!-- <div class="col-md-4">
                      <label for="parent_phone" class="form-label">Telepon Orang Tua</label>
                      <input type="tel" class="form-control" id="parent_phone" name="parent_phone"
                        :value="currentData?.parent_phone" placeholder="Masukkan telepon orang tua">
                    </div> -->
                    <div class="col-md-4">
                      <label for="address" class="form-label">Alamat</label>
                      <textarea class="form-control" id="address" name="address" rows="2"
                        placeholder="Masukkan alamat">{{ currentData?.address }}</textarea>
                    </div>
                    <div class="col-md-4">
                      <label v-if="typePasien=='anak'" for="parent_phone" class="form-label">Telepon Orang Tua</label>
                      <label v-else for="phone" class="form-label">Telepon</label>
                      <input type="tel" class="form-control" id="phone" name="phone" :value="currentData?.phone"
                        placeholder="Masukkan telepon">
                    </div>
                  </div>

                  <!-- Baris 4: Pekerjaan, Pendidikan -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <label for="occupation" class="form-label">Pekerjaan</label>
                      <input type="text" class="form-control" id="occupation" name="occupation"
                        :value="currentData?.occupation" placeholder="Masukkan pekerjaan">
                    </div>
                    <div class="col-md-6">
                      <label for="education" class="form-label">Pendidikan</label>
                      <input type="text" class="form-control" id="education" name="education"
                        :value="currentData?.education" placeholder="Masukkan pendidikan">
                    </div>
                  </div>

                  <!-- Baris 5: Usia Kehamilan, Jumlah Kehamilan, Perkiraan Lahir -->
                  <div class="row mb-3">
                    <div class="col-md-4">
                      <label for="pregnant_age" class="form-label">Usia Kehamilan</label>
                      <input type="number" class="form-control" id="pregnant_age" name="pregnant_age"
                        :value="currentData?.pregnant_age" placeholder="Masukkan usia kehamilan">
                    </div>
                    <div class="col-md-4">
                      <label for="pregnant_count" class="form-label">Jumlah Kehamilan</label>
                      <input type="number" class="form-control" id="pregnant_count" name="pregnant_count"
                        :value="currentData?.pregnant_count" placeholder="Masukkan jumlah kehamilan">
                    </div>
                    <div class="col-md-4">
                      <label for="estimated_birth" class="form-label">Perkiraan Lahir</label>
                      <input type="date" class="form-control" id="estimated_birth" name="estimated_birth"
                        :value="currentData?.estimated_birth">
                    </div>
                  </div>

                  <!-- Baris 6: Pemeriksaan Terakhir -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <label for="inspection" class="form-label">Pemeriksaan Terakhir</label>
                      <input type="date" class="form-control" id="inspection" name="inspection"
                        :value="currentData?.inspection">
                    </div>
                  </div>
                  <button type="submit" class="btn btn-primary">
                    {{ isEditing ? 'Update Data' : 'Simpan Data' }}
                  </button>
                </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div class="input-group mb-3">
          <input v-model="searchKey" @input="onSearchInput" type="text" class="form-control"
            placeholder="Cari Data Pasien" aria-label="Cari Data Pasien" aria-describedby="button-addon2">
        </div>
      </div>
    </div>
    <div class="card mb-4 shadow-sm" v-for="data in dataUser" :key="data.id">
      <div class="row g-0">
        <div class="w-100">
          <div class="card-body">
            <div class="d-flex justify-content-between">
              <div>
                <h5 class="card-title">{{ data.name }}</h5>
                <p class="card-text"><small class="text-muted">{{ data.email }}</small></p>
              </div>
              <div>
                <button class="btn mx-2 p-1 px-2">Hapus</button>
                <button class="btn mx-2 p-1 px-2" @click="openEditModal(data)">Edit</button>
                <button class="btn mx-2 p-1 px-2" type="button" data-bs-toggle="collapse"
                  :data-bs-target="'#multiCollapse-' + data.id" aria-expanded="false"
                  :aria-controls="'multiCollapse-' + data.id">Detail</button>
              </div>
            </div>
            <hr>
            <div class="row collapse multi-collapse" :id="'multiCollapse-' + data.id">
              <div class="col-md-6">
                <p class="card-text"><strong>Tanggal Lahir:</strong> {{ data.birth_date }}</p>
                <p class="card-text"><strong>Nama Ibu:</strong> {{ data.mother_name }}</p>
                <p class="card-text"><strong>Nama Ayah:</strong> {{ data.father_name }}</p>
                <p class="card-text"><strong>Telepon Orang Tua:</strong> {{ data.parent_phone }}</p>
                <p class="card-text"><strong>Alamat:</strong> {{ data.address }}</p>
                <p class="card-text"><strong>Telepon:</strong> {{ data.phone }}</p>
              </div>
              <div class="col-md-6">
                <p class="card-text"><strong>Pekerjaan:</strong> {{ data.occupation }}</p>
                <p class="card-text"><strong>Pendidikan:</strong> {{ data.education }}</p>
                <p class="card-text"><strong>Usia Kehamilan:</strong> {{ data.pregnant_age }}</p>
                <p class="card-text"><strong>Jumlah Kehamilan:</strong> {{ data.pregnant_count }}</p>
                <p class="card-text"><strong>Perkiraan Lahir:</strong> {{ data.estimated_birth }}</p>
                <p class="card-text"><strong>Pemeriksaan Terakhir:</strong> {{ data.inspection }}</p>
                <p class="card-text"><strong>Tipe:</strong> {{ data.type }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <nav aria-label="Page navigation">
      <ul class="d-flex justify-content-center">
        <li class="page-item" :class="{ disabled: pagination.current_page === 1 }">
          <a class="page-link" href="#" @click.prevent="changePage(pagination.current_page - 1)">Previous</a>
        </li>
        <li class="page-item" v-for="page in pagination.last_page" :key="page"
          :class="{ active: page === pagination.current_page }">
          <a class="page-link" href="#" @click.prevent="changePage(page)">{{ page }}</a>
        </li>
        <li class="page-item" :class="{ disabled: pagination.current_page === pagination.last_page }">
          <a class="page-link" href="#" @click.prevent="changePage(pagination.current_page + 1)">Next</a>
        </li>
      </ul>
    </nav>
  </div>
</template>
<script setup>
import Swal from 'sweetalert2'; // Import SweetAlert2
import { ref } from 'vue';

const dataUser = ref([]);
const searchKey = ref("");
const currentData = ref(null); // Store data for editing
const isEditing = ref(false); // Track if modal is in edit mode
const pagination = ref({
  current_page: 1,
  last_page: 1,
}); // Pagination data
let timeoutId = null; // For debounce
let abortController = null; // For cancelable fetch
const typePasien = ref("general")
// Fetch data on component mount
getData();

// Function to fetch data with debounce and cancelable fetch
async function getData() {
  if (abortController) {
    abortController.abort();
  }

  abortController = new AbortController();

  try {
    const response = await useFetch(
      `http://localhost:8000/api/users?search=${searchKey.value}&page=${pagination.value.current_page}`,
      {
        method: 'GET',
        signal: abortController.signal,
      }
    );

    dataUser.value = response.data.value?.data.data;
    pagination.value = {
      current_page: response.data.value?.data.current_page,
      last_page: response.data.value?.data.last_page,
    };

    if (response.status.value === "success") {
      console.log("Data fetched successfully");
    } else {
      await Swal.fire({
        icon: 'error',
        title: 'Gagal!',
        text: 'Gagal Mendapatkan Data User. Silakan Muat Ulang.',
      });
    }
  } catch (error) {
    if (error.name !== 'AbortError') {
      console.error(error);
      await Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: error.message || 'Terjadi kesalahan saat mengambil data.',
      });
    }
  } finally {
    abortController = null;
  }
}

// Function to change page
function changePage(page) {
  if (page >= 1 && page <= pagination.value.last_page) {
    pagination.value.current_page = page;
    $("html, body").animate({ scrollTop: 0 }, "slow");
    getData();
  }
}

// Function to open modal for editing
function openEditModal(data) {
  currentData.value = data; // Set the data to be edited
  isEditing.value = true; // Set modal to edit mode

  // Open the modal
  const modal = new bootstrap.Modal(document.getElementById('exampleModal'));
  modal.show();
}

// Function to reset modal to add mode
function resetModal() {
  currentData.value = null;
  isEditing.value = false;
}

// Function to save or update data
async function saveData(event) {
  event.preventDefault(); // Prevent default form submission

  let body;
  let headers = {};

  if (isEditing.value) {
    // Convert FormData to JSON for updating (PUT)
    const formDataObj = Object.fromEntries(new FormData(event.target).entries());
    body = JSON.stringify(formDataObj);
    headers["Content-Type"] = "application/json";
  } else {
    // Use FormData for creating (POST)
    body = new FormData(event.target);
  }

  try {
    const url = isEditing.value
      ? `http://localhost:8000/api/users/${currentData.value.id}` // Update existing user
      : "http://localhost:8000/api/users"; // Add new user

    const method = isEditing.value ? "PUT" : "POST";

    const data = await useFetch(url, {
      method,
      body,
      headers, // Apply headers only when sending JSON
    });

    const response = data.data.value;

    if (data.status.value === "success") {
      await Swal.fire({
        icon: "success",
        title: "Berhasil!",
        text: isEditing.value ? "Data pasien berhasil diperbarui." : "Data pasien berhasil disimpan.",
      });

      // Close the modal
      const modal = bootstrap.Modal.getInstance(document.getElementById("exampleModal"));
      modal.hide();

      // Reset the form and modal state
      event.target.reset();
      resetModal();

      // Refresh the data
      getData();
    } else {
      await Swal.fire({
        icon: "error",
        title: "Gagal!",
        text: "Gagal menyimpan data. Silakan coba lagi.",
      });
    }
  } catch (error) {
    console.error(error);
    await Swal.fire({
      icon: "error",
      title: "Error!",
      text: error.message || "Terjadi kesalahan saat menyimpan data.",
    });
  }
}

// Debounced search input handler
function onSearchInput() {
  if (timeoutId) {
    clearTimeout(timeoutId);
  }

  timeoutId = setTimeout(() => {
    getData();
  }, 2000); // 2-second debounce
}
</script>

<style scoped>
.container {
  max-width: 600px;
  margin: auto;
  background: #f9f9f9;
  padding: 20px;
  border-radius: 10px;
}

@media (min-width: 992px) {

  .modal-lg,
  .modal-xl {
    max-width: 800px !important;
  }
}

@media (min-width: 1200px) {
  .modal-xl {
    max-width: 1140px !important;
  }
}
</style>
