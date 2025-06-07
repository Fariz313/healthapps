<template>
  <div class="container mt-5">
    <h1 class="mb-4">Data PTM</h1>
<a class="btn bg-green" href="https://api.kaderpintar.id/api/ptm?export=true" target="_blank">Export Excel</a>
    <!-- Form Tambah/Edit Data -->
    <div class="card mb-4">
      <div class="card-body">
        <h5 class="card-title">{{ isEditing ? 'Edit Data' : 'Tambah Data Baru' }}</h5>
        <form @submit.prevent="saveData">
          <div class="row g-3">
            <!-- User ID with VueMultiselect -->
            <div class="col-md-6">
              <label for="user_id" class="form-label">Pasien</label>
              <VueMultiselect v-model="form.user_id" :options="userOptions" :searchable="true"
                :loading="isFetchingUsers" label="name" track-by="id" placeholder="Cari user..."
                @search-change="fetchUsers" />
            </div>
            <div class="col-md-6">
              <label for="recorded_by" class="form-label">PKM</label>
              <input v-model="recorded_by" readonly type="text" class="form-control" id="recorded_by">
            </div>

            <!-- Numeric Fields -->
            <div class="col-md-4" v-for="field in numericFields" :key="field.name">
              <label :for="field.name" class="form-label">{{ field.label }}</label>
              <input v-model="form[field.name]" type="number" step="0.1" class="form-control" :id="field.name">
            </div>

            <!-- Boolean Fields -->
            <div class="col-md-6" v-for="field in booleanFields" :key="field.name">
              <label class="form-label">{{ field.label }}</label>
              <select v-model="form[field.name]" class="form-select">
                <option disabled selected>Pilih</option>
                <option :value="true">Ya</option>
                <option :value="false">Tidak</option>
              </select>
            </div>
          </div>

          <button type="submit" class="btn btn-primary mt-3">
            {{ isEditing ? 'Update Data' : 'Tambah Data' }}
          </button>
          <button v-if="isEditing" type="button" class="btn btn-secondary mt-3 ms-2" @click="cancelEdit">
            Batal
          </button>
        </form>
      </div>
    </div>

    <!-- List Data dalam Card -->
    <div class="row">
      <div v-for="record in records" :key="record.id" class="col-md-6 col-lg-4 mb-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Pasien: {{ record.name }}</h5>
            <p class="card-text">
              <strong>PKM:</strong> {{ record.recorded_by }}<br>
              <strong>Tanggal:</strong> {{ formatDate(record.created_at) }}<br>
              <template v-for="field in allFields" :key="field.name">
                <div>
                  <p> <strong>{{ field.label }} :</strong> {{ record[field.name] }} {{ field.unit }}
                  </p>
                </div>
              </template>
            </p>
            <button class="btn btn-danger btn-sm p-1 px-2  me-2" @click="deleteData(record.id)">Hapus</button>
            <button class="btn btn-info btn-sm p-1 px-2 me-2" data-bs-toggle="modal" data-bs-target="#detailModal"
              @click="openDetailModal(record)">
              Detail
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <nav aria-label="Page navigation w-100" class="mt-4">
      <ul class="pagination d-flex justify-content-center">
        <li class="page-item" :class="{ disabled: currentPage === 1 }">
          <button class="page-link" @click="changePage(currentPage - 1)">Previous</button>
        </li>
        <li class="page-item" v-for="page in totalPages" :key="page" :class="{ active: page === currentPage }">
          <button class="page-link" @click="changePage(page)">{{ page }}</button>
        </li>
        <li class="page-item" :class="{ disabled: currentPage === totalPages }">
          <button class="page-link" @click="changePage(currentPage + 1)">Next</button>
        </li>
      </ul>
    </nav>

    <div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="detailModalLabel">Detail Data Pasien</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <template v-if="(selectedRecord)">
              <div v-if="(selectedRecord.BP <= 120 && selectedRecord.BP2 <= 80)" class="alert alert-success" role="alert">
                <b>Tekanan Darah Normal Pertahankan !</b>
              </div>
              <div v-else-if="selectedRecord.BP <= 140 && selectedRecord.BP2 <= 90" class="alert alert-warning"
                role="alert">
                <b>Pre Hipertensi</b>
                <p>Anjuran Perubahan Gaya Hidup</p>
                <ol>
                  <li>
                    Penurunan Berat Badan
                    <br>
                    Jaga berat badan ideal IMT: 18.5 - 22.9 kg/m2
                  </li>
                  <li>
                    Diet Tinggi serat dan rendah lemak (DASH)
                  </li>
                  <li>Pembatasan intake natrium <br>
                    Kurangi 2,0 gr natrium atau 1 sendok teh garam per hari
                  </li>
                  <li>
                    Aktifitas fisik aerobik
                    <br>
                    Aktifitas fisik aerobik yang teratur 20-30 menit dengan frekuensi 2-3 kali seminggu
                  </li>
                  <li>
                    Pembatasan konsumsi alkohol
                    <br>
                    max 30ml bagi laki-laki
                    <br>
                    max 20ml bagi perempuan
                  </li>
                  <li>
                    Pembatasan merokok
                  </li>
                </ol>
              </div>
              <div v-else-if="selectedRecord.BP <= 160 && selectedRecord.BP2 <= 100" class="alert alert-warning"
                role="alert">
                <b>Pre Hipertensi</b>
                <p>Anjuran Perubahan Gaya Hidup</p>
                <ol>
                  <li>
                    Penurunan Berat Badan
                    <br>
                    Jaga berat badan ideal IMT: 18.5 - 22.9 kg/m2
                  </li>
                  <li>
                    Diet Tinggi serat dan rendah lemak (DASH)
                  </li>
                  <li>Pembatasan intake natrium <br>
                    Kurangi 2,0 gr natrium atau 1 sendok teh garam per hari
                  </li>
                  <li>
                    Aktifitas fisik aerobik
                    <br>
                    Aktifitas fisik aerobik yang teratur 20-30 menit dengan frekuensi 2-3 kali seminggu
                  </li>
                  <li>
                    Pembatasan konsumsi alkohol
                    <br>
                    max 30ml bagi laki-laki
                    <br>
                    max 20ml bagi perempuan
                  </li>
                  <li>
                    Pembatasan merokok
                  </li>
                </ol>
                <p>Segera kunjungi fasilitas kesehatan jika 2 minggu pasca modifikasi gaya hidup target tekanan darah
                  tidak tercapai</p>
              </div>
              <div v-else-if="selectedRecord.BP <= 160 && selectedRecord.BP2 <= 100" class="alert alert-warning"
                role="alert">
                <b>Pre Hipertensi grade 2</b>
                <p>Segera datangi fasilitas kesehatan untuk mendapat pengobatan dari dokter</p>
                <ol>
                  <li>Dilakukan pengobatan & pengawasan oleh dokter</li>
                </ol>
                <p>Anjuran Perubahan Gaya Hidup</p>
                <ol>
                  <li>
                    Penurunan Berat Badan
                    <br>
                    Jaga berat badan ideal IMT: 18.5 - 22.9 kg/m2
                  </li>
                  <li>
                    Diet Tinggi serat dan rendah lemak (DASH)
                  </li>
                </ol>
              </div>
              <p><strong>Pasien:</strong> {{ selectedRecord.name }}</p>
              <p><strong>Recorded By:</strong> {{ selectedRecord.recorded_by }}</p>
              <p><strong>Tanggal:</strong> {{ formatDate(selectedRecord.created_at) }}</p>

              <template v-for="field in allFields" :key="field.name">

                <div>
                  <p> <strong>{{ field.label }} :</strong> {{ selectedRecord[field.name] }} {{ field.unit }}
                  </p>
                </div>
              </template>
            </template>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline-success" @click="shareLink">Share Link</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watchEffect } from 'vue';
import VueMultiselect from 'vue-multiselect';
const selectedUser = ref(null);
// Fields configuration
const numericFields = ref([
  { unit: "Kg", name: 'weight', label: 'Berat' },
  { unit: "Cm", name: 'height', label: 'Tinggi' },
  { unit: "mmhg", name: 'BP', label: 'Tekanan sistolik' },
  { unit: "mmhg", name: 'BP2', label: 'Tekanan diastolik' },
  { unit: "", name: 'GDS', label: 'GDS' },
  { unit: "", name: 'GDP', label: 'GDP' }
]);
const selectedRecord = ref(null);

const booleanFields = ref([]);

const allFields = ref([...numericFields.value, ...booleanFields.value]);

const currentPage = ref(1);
const totalPages = ref(1);
const perPage = ref(6);

const records = ref([]);
const form = ref({
  weight: "",
  height: "",
  BP: "",
  BP2: "",
  GDS: "",
  GDP: ""
});
const isEditing = ref(false);
function calculatePoints(record) {
  let totalPoints = 0;

  booleanFields.value.forEach(field => {
    if (record[field.name] === 1) {
      totalPoints += field.point;
    }
  });

  return totalPoints;
}
console.log(form.value);

// User selection data
const userOptions = ref([]);
const isFetchingUsers = ref(false);
function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page;
    fetchRecords();
  }
}
// Fetch all records from API
async function fetchRecords() {
  try {
    const response = await fetch(`https://api.kaderpintar.id/api/ptm?page=${currentPage.value}`);
    const data = await response.json();
    totalPages.value = data.data.last_page;
    const recordsWithPoints = data.data.data.map(record => {
      return {
        ...record,
        totalPoints: calculatePoints(record),
      };
    });

    records.value = recordsWithPoints;
  } catch (error) {
    console.error("Error fetching records:", error);
  }
}

// Fetch users from API
async function fetchUsers(query) {
  if (!query) return;
  isFetchingUsers.value = true;
  try {
    const response = await fetch(`https://api.kaderpintar.id/api/users?search=${query}`);
    const data = await response.json();
    userOptions.value = data.data.data.map(user => ({ id: user.id, name: user.name }));

  } catch (error) {
    console.error("Error fetching users:", error);
  } finally {
    isFetchingUsers.value = false;
  }
}

// Save or update data
async function saveData() {
  try {
    const url = isEditing.value
      ? `https://api.kaderpintar.id/api/ptm/${form.value.id}`
      : 'https://api.kaderpintar.id/api/ptm';

    const method = isEditing.value ? 'PUT' : 'POST';
    let body = form.value
    body.user_id = form.value.user_id.id
    body.recorded_by = await JSON.parse(localStorage.getItem('user')).id
    const data = await useFetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });
    const response = data.data.value;

    if (data.status.value != "success") throw new Error("Gagal menyimpan data.");

    fetchRecords(); // Refresh data
    resetForm();
  } catch (error) {
    console.error("Error saving data:", error);
  }
}

// Edit Data
function editData(record) {
  form.value = { ...record };
  isEditing.value = true;
}
function cancelEdit() {
  form.value = {
    weight: "",
    height: "",
    td: "",
    gds: "",
    gdp: ""
  }
  isEditing.value = false;

}
// Delete Data
async function deleteData(id) {
  try {
    const response = await fetch(`https://api.kaderpintar.id/api/ptm/${id}`, {
      method: 'DELETE',
    });

    if (!response.ok) throw new Error("Gagal menghapus data.");

    fetchRecords(); // Refresh data
  } catch (error) {
    console.error("Error deleting data:", error);
  }
}

// Reset Form
function resetForm() {
  form.value = {};
  isEditing.value = false;
}

// Format Boolean Values for Display
function formatValue(value) {
  if (value === true) return 'Ya';
  if (value === false) return 'Tidak';
  return value ?? '-';
}
function openDetailModal(record) {
  selectedRecord.value = record;
}

// Fetch records on component mount
fetchRecords();
const recorded_by = ref("");
if (process.client) {
  form.recorded_by = JSON.parse(localStorage.getItem('user')).id
  recorded_by.value = JSON.parse(localStorage.getItem('user')).name


}
function formatDate(dateString) {
  const date = new Date(dateString);

  // Convert to WIB (UTC+7)
  const wibOffset = 7 * 60; // WIB is UTC+7
  const wibDate = new Date(date.getTime() + wibOffset * 60 * 1000);

  // Format the date
  const options = {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    timeZone: 'Asia/Jakarta'
  };

  const formattedDate = wibDate.toLocaleString('en-GB', options).replace(',', '');

  return formattedDate;
}

const showQr = ref(false);
const runtimeConfig = useRuntimeConfig();

function getDetailLink() {
  const baseUrl = runtimeConfig.public.siteUrl || 'http://localhost:3000'; // fallback
  return `${baseUrl}/ptm/detail?id=${selectedRecord.value?.id}`;
}

function copyLink() {
  const link = getDetailLink();
  navigator.clipboard.writeText(link)
    .then(() => alert('Link berhasil disalin!'))
    .catch(err => alert('Gagal menyalin: ' + err));
}

function shareLink() {
  const link = getDetailLink();
  if (navigator.share) {
    navigator.share({
      title: 'Detail Data Pasien',
      text: 'Lihat detail data pasien di link berikut:',
      url: link
    }).catch(err => alert('Gagal membagikan: ' + err));
  } else {
    alert('Fitur berbagi tidak didukung di perangkat ini.');
  }
}

</script>