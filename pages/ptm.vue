<template>
  <div class="container mt-5">
    <h1 class="mb-4">Data Ibu Hamil</h1>

    <!-- Form Tambah/Edit Data -->
    <div class="card mb-4">
      <div class="card-body">
        <h5 class="card-title">{{ isEditing ? 'Edit Data' : 'Tambah Data Baru' }}</h5>
        <form @submit.prevent="saveData">
          <div class="row g-3">
            <div class="col-md-6">
              <label for="user_id" class="form-label">User ID</label>
              <input v-model="form.user_id" type="number" class="form-control" id="user_id" required>
            </div>
            <div class="col-md-6">
              <label for="recorded_by" class="form-label">Recorded By</label>
              <input v-model="form.recorded_by" type="number" class="form-control" id="recorded_by">
            </div>
            <div class="col-md-4">
              <label for="weight" class="form-label">Weight</label>
              <input v-model="form.weight" type="number" step="0.1" class="form-control" id="weight">
            </div>
            <div class="col-md-4">
              <label for="height" class="form-label">Height</label>
              <input v-model="form.height" type="number" step="0.1" class="form-control" id="height">
            </div>
            <div class="col-md-4">
              <label for="age_at_pregnancy" class="form-label">Age at Pregnancy</label>
              <input v-model="form.age_at_pregnancy" type="number" step="0.1" class="form-control" id="age_at_pregnancy">
            </div>
            <!-- Boolean Fields -->
            <div class="col-md-6">
              <label class="form-label">Young Pregnant</label>
              <select v-model="form.young_pregnant" class="form-select">
                <option :value="null">Pilih</option>
                <option :value="true">Ya</option>
                <option :value="false">Tidak</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label">Old Pregnant</label>
              <select v-model="form.old_pregnant" class="form-select">
                <option :value="null">Pilih</option>
                <option :value="true">Ya</option>
                <option :value="false">Tidak</option>
              </select>
            </div>
            <!-- Tambahkan field boolean lainnya dengan cara yang sama -->
            <div class="col-md-6">
              <label class="form-label">Twin Birth</label>
              <select v-model="form.twin_birth" class="form-select">
                <option :value="null">Pilih</option>
                <option :value="true">Ya</option>
                <option :value="false">Tidak</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label">Preeklampsia</label>
              <select v-model="form.preeklampsia" class="form-select">
                <option :value="null">Pilih</option>
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
      <div v-for="record in records" :key="record.id" class="col-md-4 mb-4">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Pasien: {{ record.user_id }}</h5>
            <p class="card-text">
              <strong>Recorded By:</strong> {{ record.recorded_by }}<br>
              <strong>Weight:</strong> {{ record.weight }} kg<br>
              <strong>Height:</strong> {{ record.height }} cm<br>
              <strong>Age at Pregnancy:</strong> {{ record.age_at_pregnancy }}<br>
              <strong>Young Pregnant:</strong> {{ record.young_pregnant ? 'Ya' : 'Tidak' }}<br>
              <strong>Old Pregnant:</strong> {{ record.old_pregnant ? 'Ya' : 'Tidak' }}<br>
              <strong>Twin Birth:</strong> {{ record.twin_birth ? 'Ya' : 'Tidak' }}<br>
              <strong>Preeklampsia:</strong> {{ record.preeklampsia ? 'Ya' : 'Tidak' }}<br>
            </p>
            <button class="btn btn-sm btn-warning me-2" @click="editData(record)">Edit</button>
            <button class="btn btn-sm btn-danger" @click="deleteData(record.id)">Hapus</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

// Data simulasi
const records = ref([
  {
    id: 1,
    user_id: 101,
    recorded_by: 201,
    weight: 65.5,
    height: 170,
    age_at_pregnancy: 28,
    young_pregnant: true,
    old_pregnant: false,
    twin_birth: false,
    preeklampsia: true,
  },
  {
    id: 2,
    user_id: 102,
    recorded_by: 202,
    weight: 60,
    height: 165,
    age_at_pregnancy: 32,
    young_pregnant: false,
    old_pregnant: true,
    twin_birth: true,
    preeklampsia: false,
  },
]);

// Form untuk tambah/edit data
const form = ref({
  id: null,
  user_id: null,
  recorded_by: null,
  weight: null,
  height: null,
  age_at_pregnancy: null,
  young_pregnant: null,
  old_pregnant: null,
  twin_birth: null,
  preeklampsia: null,
});

const isEditing = ref(false);

// Tambah/Update Data
function saveData() {
  if (isEditing.value) {
    // Update data yang sudah ada
    const index = records.value.findIndex((r) => r.id === form.value.id);
    if (index !== -1) {
      records.value[index] = { ...form.value };
    }
  } else {
    // Tambah data baru
    const newRecord = {
      id: records.value.length + 1,
      ...form.value,
    };
    records.value.push(newRecord);
  }
  resetForm();
}

// Edit Data
function editData(record) {
  form.value = { ...record };
  isEditing.value = true;
}

// Hapus Data
function deleteData(id) {
  records.value = records.value.filter((record) => record.id !== id);
}

// Batal Edit
function cancelEdit() {
  resetForm();
}

// Reset Form
function resetForm() {
  form.value = {
    id: null,
    user_id: null,
    recorded_by: null,
    weight: null,
    height: null,
    age_at_pregnancy: null,
    young_pregnant: null,
    old_pregnant: null,
    twin_birth: null,
    preeklampsia: null,
  };
  isEditing.value = false;
}
</script>

<style scoped>
.card {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
.card-title {
  font-size: 1.25rem;
  font-weight: bold;
}
.card-text {
  font-size: 0.9rem;
}
</style>