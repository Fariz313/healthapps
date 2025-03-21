<template>
  <div class="container mt-5">
    <h1 class="mb-4">Data Gizi Anak</h1>

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
              <label for="recorded_by" class="form-label">Nama Pendata</label>
              <input v-model="recorded_by" readonly type="text" class="form-control" id="recorded_by">
            </div>

            <!-- Numeric Fields -->
            <div class="col-md-4" v-for="field in numericFields" :key="field.name">
              <label :for="field.name" class="form-label">{{ field.label }}</label>
              <input v-model="form[field.name]" :readonly="field.readonly" type="number" step="0.1" class="form-control" :id="field.name">
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
              <strong>Petugas:</strong> {{ record.recorded_by }}<br>
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

    <div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="detailModalLabel">Detail Data Pasien</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <template v-if="(selectedRecord)">
              <p><strong>Pasien:</strong> {{ selectedRecord.name }}</p>
              <p><strong>Recorded By:</strong> {{ selectedRecord.recorded_by }}</p>
              <p><strong>Tanggal:</strong> {{ formatDate(selectedRecord.created_at) }}</p>

              <template v-for="field in allFields" :key="field.name">

                <div>
                  <p> <strong>{{ field.label }} :</strong> {{ selectedRecord[field.name] }} {{ field.unit }}
                  </p>
                </div>
              </template>

              <h3>Hasil Kalkulasi & Rekomendasi:</h3>
            </template>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import VueMultiselect from 'vue-multiselect';
const selectedUser = ref(null);
// Fields configuration
const numericFields = ref([
  { unit: "Kg", name: 'weight', label: 'Berat' ,readonly:false},
  { unit: "Cm", name: 'height', label: 'Tinggi',readonly:false },
  { unit: "bulan", name: 'age', label: 'Usia saat ini',readonly:true,custom:'usia' }
]);
const selectedRecord = ref(null);

const booleanFields = ref([]);

const allFields = ref([...numericFields.value, ...booleanFields.value]);

const records = ref([]);
const form = ref({
  weight: "",
  height: "",
  age: "",
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

// Fetch all records from API
async function fetchRecords() {
  try {
    const response = await useFetch('https://api.kaderpintar.id/api/gizi');
    const recordsWithPoints = response.data.value?.data.data.map(record => {
      return {
        ...record,
        totalPoints: calculatePoints(record),
      };
    });
    records.value = recordsWithPoints;
    console.log("data in");
    console.log("data", records.value);

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
    userOptions.value = data.data.data.map(user => ({ id: user.id, name: user.name, birth_date: user.birth_date }));

    console.log("KEPILIH", form.value.user_id);
    
    // Jika pasien sudah dipilih, hitung usia dalam bulan
    if (form.value.user_id) {
      const selectedUser = userOptions.value.find(user => user.id === form.value.user_id.id);
      if (selectedUser) {
        form.value.age = calculateAgeInMonths(selectedUser.birth_date);
      }
    }

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
      ? `https://api.kaderpintar.id/api/gizi/${form.value.id}`
      : 'https://api.kaderpintar.id/api/gizi';

    const method = isEditing.value ? 'PUT' : 'POST';
    let body = form.value
    body.user_id = form.value.user_id.id
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
  }
  isEditing.value = false;

}
// Delete Data
async function deleteData(id) {
  try {
    const response = await fetch(`https://api.kaderpintar.id/api/gizi/${id}`, {
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

function calculateAgeInMonths(birthDate) {
  const today = new Date();
  const birthDateObj = new Date(birthDate);

  const yearDiff = today.getFullYear() - birthDateObj.getFullYear();
  const monthDiff = today.getMonth() - birthDateObj.getMonth();
  const dayDiff = today.getDate() - birthDateObj.getDate();

  let ageInMonths = yearDiff * 12 + monthDiff;
  
  // If the birth date hasn't passed this year yet, subtract 1 month
  if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
    ageInMonths--;
  }

  return ageInMonths;
}
watch(() => form.value.user_id, (newUserId) => {
  if (newUserId) {
    const selectedUser = userOptions.value.find(user => user.id === newUserId.id);
    if (selectedUser) {
      form.value.age = calculateAgeInMonths(selectedUser.birth_date);
    }
  } else {
    form.value.age = ""; // Reset age jika tidak ada user yang dipilih
  }
});

</script>