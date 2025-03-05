<template>
  <div class="container-fluid mt-5">
    <div class="d-flex justify-content-between">
      <h1>Data Pasien</h1>
      <div>
        <!-- Button trigger modal -->
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
          Tambah Data Pasien
        </button>

        <!-- Modal -->
        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-xl">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Tambah Data Pasien</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <form @submit.prevent="saveData">
                  <!-- Baris 1: Nama, Email, Foto Profil -->
                  <div class="row mb-3">
                    <div class="col-md-4">
                      <label for="name" class="form-label">Nama Lengkap</label>
                      <input type="text" class="form-control" id="name" name="name" placeholder="Masukkan nama lengkap">
                    </div>
                    <div class="col-md-4">
                      <label for="email" class="form-label">Email</label>
                      <input type="email" class="form-control" id="email" name="email" placeholder="Masukkan email">
                    </div>
                    <!-- <div class="col-md-4">
                      <label for="photo_profile" class="form-label">Foto Profil</label>
                      <input type="file" class="form-control" id="photo_profile" name="photo_profile">
                    </div> -->
                  </div>

                  <!-- Baris 2: Tanggal Lahir, Nama Ibu, Nama Ayah -->
                  <div class="row mb-3">
                    <div class="col-md-4">
                      <label for="birth_date" class="form-label">Tanggal Lahir</label>
                      <input type="date" class="form-control" id="birth_date" name="birth_date">
                    </div>
                    <div class="col-md-4">
                      <label for="mother_name" class="form-label">Nama Ibu</label>
                      <input type="text" class="form-control" id="mother_name" name="mother_name"
                        placeholder="Masukkan nama ibu">
                    </div>
                    <div class="col-md-4">
                      <label for="father_name" class="form-label">Nama Ayah</label>
                      <input type="text" class="form-control" id="father_name" name="father_name"
                        placeholder="Masukkan nama ayah">
                    </div>
                  </div>

                  <!-- Baris 3: Telepon Orang Tua, Alamat, Telepon -->
                  <div class="row mb-3">
                    <div class="col-md-4">
                      <label for="parent_phone" class="form-label">Telepon Orang Tua</label>
                      <input type="tel" class="form-control" id="parent_phone" name="parent_phone"
                        placeholder="Masukkan telepon orang tua">
                    </div>
                    <div class="col-md-4">
                      <label for="address" class="form-label">Alamat</label>
                      <textarea class="form-control" id="address" name="address" rows="2"
                        placeholder="Masukkan alamat"></textarea>
                    </div>
                    <div class="col-md-4">
                      <label for="phone" class="form-label">Telepon</label>
                      <input type="tel" class="form-control" id="phone" name="phone" placeholder="Masukkan telepon">
                    </div>
                  </div>

                  <!-- Baris 4: Pekerjaan, Pendidikan -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <label for="occupation" class="form-label">Pekerjaan</label>
                      <input type="text" class="form-control" id="occupation" name="occupation"
                        placeholder="Masukkan pekerjaan">
                    </div>
                    <div class="col-md-6">
                      <label for="education" class="form-label">Pendidikan</label>
                      <input type="text" class="form-control" id="education" name="education"
                        placeholder="Masukkan pendidikan">
                    </div>
                  </div>

                  <!-- Baris 5: Usia Kehamilan, Jumlah Kehamilan, Perkiraan Lahir -->
                  <div class="row mb-3">
                    <div class="col-md-4">
                      <label for="pregnant_age" class="form-label">Usia Kehamilan</label>
                      <input type="text" class="form-control" id="pregnant_age" name="pregnant_age"
                        placeholder="Masukkan usia kehamilan">
                    </div>
                    <div class="col-md-4">
                      <label for="pregnant_count" class="form-label">Jumlah Kehamilan</label>
                      <input type="number" class="form-control" id="pregnant_count" name="pregnant_count"
                        placeholder="Masukkan jumlah kehamilan">
                    </div>
                    <div class="col-md-4">
                      <label for="estimated_birth" class="form-label">Perkiraan Lahir</label>
                      <input type="date" class="form-control" id="estimated_birth" name="estimated_birth">
                    </div>
                  </div>

                  <!-- Baris 6: Pemeriksaan Terakhir, Tipe -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <label for="inspection" class="form-label">Pemeriksaan Terakhir</label>
                      <input type="date" class="form-control" id="inspection" name="inspection">
                    </div>
                  </div>
                  <button type="submit" class="btn btn-primary">Simpan Data</button>

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
          <input v-model="searchKey" @input="onSearchInput" type="text" class="form-control" placeholder="Cari Data Pasien" aria-label="Cari Data Pasien"
            aria-describedby="button-addon2">
        </div>
      </div>
    </div>
    <div class="card mb-4 shadow-sm" v-for="data in dataUser">
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
                <button class="btn mx-2 p-1 px-2">Edit</button>
                <button class="btn mx-2 p-1 px-2" type="button" data-bs-toggle="collapse"
                  :data-bs-target="'#multiCollapse-' + data.id" aria-expanded="false"
                  :aria-controls="'multiCollapse-' + data.id">Detail</button>
              </div>
            </div>
            <hr>
            <div class="row collapse multi-collapse" :id="'multiCollapse-' + data.id">
              <div class="col-md-6">
                <p class="card-text"><strong>Tanggal Lahir:</strong> 1990-01-01</p>
                <p class="card-text"><strong>Nama Ibu:</strong> Jane Doe</p>
                <p class="card-text"><strong>Nama Ayah:</strong> John Doe Sr.</p>
                <p class="card-text"><strong>Telepon Orang Tua:</strong> +62 123 4567 890</p>
                <p class="card-text"><strong>Alamat:</strong> Jl. Contoh No. 123, Jakarta</p>
                <p class="card-text"><strong>Telepon:</strong> +62 987 6543 210</p>
              </div>
              <div class="col-md-6">
                <p class="card-text"><strong>Pekerjaan:</strong> Software Engineer</p>
                <p class="card-text"><strong>Pendidikan:</strong> S1 Teknik Informatika</p>
                <p class="card-text"><strong>Usia Kehamilan:</strong> 28 Minggu</p>
                <p class="card-text"><strong>Jumlah Kehamilan:</strong> 2</p>
                <p class="card-text"><strong>Perkiraan Lahir:</strong> 2023-12-01</p>
                <p class="card-text"><strong>Pemeriksaan Terakhir:</strong> 2023-10-01</p>
                <p class="card-text"><strong>Tipe:</strong> Normal</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import Swal from 'sweetalert2'; // Import SweetAlert2
const dataUser = ref({})
const searchKey = ref("")
let timeoutId = null; // For debounce
let abortController = null; // For cancelable fetch

getData();
async function getData() {
  // Cancel the previous request if it exists
  if (abortController) {
    abortController.abort();
  }

  // Create a new AbortController for the current request
  abortController = new AbortController();

  try {
    const response = await useFetch('http://localhost:8000/api/users?search=' + searchKey.value, {
      method: 'GET',
      signal: abortController.signal, // Pass the signal to cancel the request
    });

    // Update data if the request is successful
    dataUser.value = response.data.value?.data.data;

    if (response.status.value === "success") {
      console.log("Data fetched successfully");
    } else {
      // Show error message if the request fails
      await Swal.fire({
        icon: 'error',
        title: 'Gagal!',
        text: 'Gagal Mendapatkan Data User. Silakan Muat Ulang.',
      });
    }
  } catch (error) {
    // Handle errors (including aborted requests)
    if (error.name !== 'AbortError') {
      console.error(error);
      await Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: error.message || 'Terjadi kesalahan saat mengambil data.',
      });
    }
  } finally {
    // Reset the AbortController after the request is complete
    abortController = null;
  }
}
async function saveData(event) {
  const formData = new FormData(event.target);

  try {
    const data = await useFetch('http://localhost:8000/api/users', {
      method: 'POST',
      body: formData,
    });
    const response = data.data.value
    console.log(response);
    console.log(data.status.value);

    // Check if the HTTP status code is in the 2xx range
    if (data.status.value == "success") {
      // Tampilkan SweetAlert2 untuk sukses
      await Swal.fire({
        icon: 'success',
        title: 'Berhasil!',
        text: 'Data pasien berhasil disimpan.',
      });

      // Tutup modal
      const modal = bootstrap.Modal.getInstance(document.getElementById('exampleModal'));
      modal.hide();

      // Reset form
      event.target.reset();
    } else {
      // Tampilkan SweetAlert2 untuk gagal
      await Swal.fire({
        icon: 'error',
        title: 'Gagal!',
        text: 'Gagal menyimpan data. Silakan coba lagi.',
      });
    }
  } catch (error) {
    console.log(error);
    // Tampilkan SweetAlert2 untuk error
    await Swal.fire({
      icon: 'error',
      title: 'Error!',
      text: error.message || 'Terjadi kesalahan saat menyimpan data.',
    });
  }
}
// Debounced search input handler
function onSearchInput() {
  // Clear the previous timeout
  if (timeoutId) {
    clearTimeout(timeoutId);
  }

  // Set a new timeout for 2 seconds
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