<template>
  <div class="container mt-5">
    <h1 class="mb-4">Data Gizi Anak</h1>
    <a class="btn bg-green" href="https://api.kaderpintar.id/api/gizi?export=true" target="_blank">Export Excel</a>

    <!-- Form Tambah/Edit Data -->
    <div class="card mb-4">
      <div class="card-body">
        <h5 class="card-title">{{ isEditing ? 'Edit Data' : 'Tambah Data Baru' }}</h5>
        <form @submit.prevent="handleSubmit">
          <div class="row g-3">
            <!-- User ID with VueMultiselect -->
            <div class="col-md-6">
              <label for="user_id" class="form-label">Pasien</label>
              <VueMultiselect 
                v-model="form.user_id" 
                :options="userOptions" 
                :searchable="true"
                :loading="isFetchingUsers" 
                label="name" 
                track-by="id" 
                placeholder="Cari user..."
                @search-change="fetchUsers" 
              />
              <div v-if="errors.user_id" class="text-danger small">{{ errors.user_id }}</div>
            </div>
            
            <div class="col-md-6">
              <label for="recorded_by" class="form-label">Nama Pendata</label>
              <input v-model="recorded_by" readonly type="text" class="form-control" id="recorded_by">
            </div>

            <!-- Numeric Fields -->
            <div class="col-md-4" v-for="field in numericFields" :key="field.name">
              <label :for="field.name" class="form-label">{{ field.label }}</label>
              <input 
                v-model.number="form[field.name]" 
                :readonly="field.readonly" 
                type="number" 
                step="0.1" 
                class="form-control"
                :id="field.name"
                @blur="validateField(field.name)"
              >
              <div v-if="errors[field.name]" class="text-danger small">{{ errors[field.name] }}</div>
            </div>
          </div>

          <button type="submit" class="btn btn-primary mt-3" :disabled="isSubmitting">
            <span v-if="isSubmitting">
              <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
              Processing...
            </span>
            <span v-else>{{ isEditing ? 'Update Data' : 'Tambah Data' }}</span>
          </button>
          
          <button 
            v-if="isEditing" 
            type="button" 
            class="btn btn-secondary mt-3 ms-2" 
            @click="resetForm"
            :disabled="isSubmitting"
          >
            Batal
          </button>
        </form>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="text-center my-5">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <p class="mt-2">Memuat data...</p>
    </div>

    <!-- Empty State -->
    <div v-else-if="records.length === 0" class="alert alert-info">
      Tidak ada data gizi yang tersedia.
    </div>

    <!-- List Data dalam Card -->
    <div v-else class="row">
      <div v-for="record in records" :key="record.id" class="col-md-6 col-lg-4 mb-4">
        <div class="card h-100">
          <div class="card-body d-flex flex-column">
            <h5 class="card-title">Pasien: {{ record.name }}</h5>
            <div class="card-text flex-grow-1">
              <strong>Petugas:</strong> {{ record.recorded_by }}<br>
              <strong>Tanggal:</strong> {{ formatDate(record.created_at) }}<br>
              <template v-for="field in allFields" :key="field.name">
                <div>
                  <p><strong>{{ field.label }}:</strong> {{ record[field.name] }} {{ field.unit }}</p>
                </div>
              </template>
            </div>
            <div class="mt-auto">
              <button class="btn btn-danger btn-sm p-1 px-2 me-2" @click="confirmDelete(record.id)">
                Hapus
              </button>
              <button class="btn btn-info btn-sm p-1 px-2 me-2" @click="openDetailModal(record)">
                Detail
              </button>
              <button class="btn btn-warning btn-sm p-1 px-2" @click="editData(record)">
                Edit
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <nav v-if="records.length > 0" aria-label="Page navigation" class="mt-4">
      <ul class="pagination d-flex justify-content-center">
        <li class="page-item" :class="{ disabled: currentPage === 1 }">
          <button class="page-link" @click="changePage(currentPage - 1)">Previous</button>
        </li>
        <li 
          class="page-item" 
          v-for="page in visiblePages" 
          :key="page" 
          :class="{ active: page === currentPage }"
        >
          <button class="page-link" @click="changePage(page)">{{ page }}</button>
        </li>
        <li class="page-item" :class="{ disabled: currentPage === totalPages }">
          <button class="page-link" @click="changePage(currentPage + 1)">Next</button>
        </li>
      </ul>
    </nav>

    <!-- Detail Modal -->
    <NutritionDetailModal
      ref="nutritionDetailModal" 
      :record="selectedRecord"
      :growth-standards="growthStandards"
      @close="closeDetailModal"
      @share="shareLink"
    />
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import VueMultiselect from 'vue-multiselect';
import NutritionDetailModal from './NutritionDetailModal.vue';
// import { useConfirmDialog } from '@vueuse/core';
// import { useToast } from 'vue-toastification';

// Constants
const NUMERIC_FIELDS = [
  { unit: "Kg", name: 'weight', label: 'Berat', readonly: false, min: 0, max: 100 },
  { unit: "Cm", name: 'height', label: 'Tinggi', readonly: false, min: 0, max: 200 },
  { unit: "bulan", name: 'age', label: 'Usia saat ini', readonly: true }
];

// Composables
// const toast = useToast();

// Reactive State
const records = ref([]);
const form = ref({
  user_id: null,
  weight: null,
  height: null,
  age: null
});
const errors = ref({});
const isEditing = ref(false);
const isLoading = ref(false);
const isSubmitting = ref(false);
const currentPage = ref(1);
const totalPages = ref(1);
const perPage = ref(6);
const userOptions = ref([]);
const isFetchingUsers = ref(false);
const recorded_by = ref("");
const selectedRecord = ref(null);
const growthStandards = ref({
  BBPB: { L: null, P: null },
  BBTB: { L: null, P: null },
  BBU: { L: null, P: null },
  IMTU: { L: null, P: null },
  TBU: { L: null, P: null }
});
const nutritionDetailModal = ref(null)
// Computed Properties
const numericFields = computed(() => NUMERIC_FIELDS);
const allFields = computed(() => [...numericFields.value]);
const visiblePages = computed(() => {
  const pages = [];
  const maxVisible = 5;
  let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2));
  let end = Math.min(totalPages.value, start + maxVisible - 1);
  
  if (end - start + 1 < maxVisible) {
    start = Math.max(1, end - maxVisible + 1);
  }
  
  for (let i = start; i <= end; i++) {
    pages.push(i);
  }
  
  return pages;
});

// Lifecycle Hooks
onMounted(() => {
  initializeForm();
  fetchRecords();
  loadGrowthStandards();
});

// Methods
function initializeForm() {
  if (process.client) {
    const user = JSON.parse(localStorage.getItem('user'));
    if (user) {
      recorded_by.value = user.name;
      form.value.recorded_by = user.id;
    }
  }
}

async function fetchRecords() {
  try {
    isLoading.value = true;
    const response = await fetch(`https://api.kaderpintar.id/api/gizi?page=${currentPage.value}`);
    const data = await response.json();
    
    if (response.ok) {
      records.value = data.data.data;
      totalPages.value = data.data.last_page;
    } else {
      throw new Error(data.message || 'Gagal memuat data');
    }
  } catch (error) {
    console.error("Error fetching records:", error);
    // toast.error(error.message || 'Terjadi kesalahan saat memuat data');
  } finally {
    isLoading.value = false;
  }
}

async function loadGrowthStandards() {
  try {
    const standards = ['BBPB', 'BBTB', 'BBU', 'IMTU', 'TBU'];
    const genders = ['L', 'P'];
    
    await Promise.all(standards.flatMap(standard => 
      genders.map(async gender => {
        const response = await fetch(`/assets/json/gizi/${standard}_${gender}.json`);
        if (response.ok) {
          growthStandards.value[standard][gender] = await response.json();
        } else {
          throw new Error(`Failed to load ${standard}_${gender}.json`);
        }
      })
    ));
  } catch (error) {
    console.error('Error loading growth standards:', error);
    // toast.error('Gagal memuat standar pertumbuhan');
  }
}

async function fetchUsers(query) {
  if (!query || query.length < 3) return;
  
  try {
    isFetchingUsers.value = true;
    const response = await fetch(`https://api.kaderpintar.id/api/users?search=${query}`);
    const data = await response.json();
    
    if (response.ok) {
      userOptions.value = data.data.data.map(user => ({ 
        id: user.id, 
        name: user.name, 
        birth_date: user.birth_date 
      }));
    } else {
      throw new Error(data.message || 'Gagal mencari pasien');
    }
  } catch (error) {
    console.error("Error fetching users:", error);
    // toast.error(error.message || 'Terjadi kesalahan saat mencari pasien');
  } finally {
    isFetchingUsers.value = false;
  }
}

function validateForm() {
  const newErrors = {};
  
  if (!form.value.user_id) {
    newErrors.user_id = 'Pasien harus dipilih';
  }
  
  NUMERIC_FIELDS.forEach(field => {
    if (!field.readonly) {
      const value = form.value[field.name];
      
      if (value === null || value === undefined || value === '') {
        newErrors[field.name] = `${field.label} harus diisi`;
      } else if (field.min !== undefined && value < field.min) {
        newErrors[field.name] = `${field.label} tidak boleh kurang dari ${field.min}`;
      } else if (field.max !== undefined && value > field.max) {
        newErrors[field.name] = `${field.label} tidak boleh lebih dari ${field.max}`;
      }
    }
  });
  
  errors.value = newErrors;
  return Object.keys(newErrors).length === 0;
}

function validateField(fieldName) {
  const field = NUMERIC_FIELDS.find(f => f.name === fieldName);
  if (!field || field.readonly) return;
  
  const value = form.value[fieldName];
  
  if (value === null || value === undefined || value === '') {
    errors.value[fieldName] = `${field.label} harus diisi`;
  } else if (field.min !== undefined && value < field.min) {
    errors.value[fieldName] = `${field.label} tidak boleh kurang dari ${field.min}`;
  } else if (field.max !== undefined && value > field.max) {
    errors.value[fieldName] = `${field.label} tidak boleh lebih dari ${field.max}`;
  } else {
    delete errors.value[fieldName];
  }
}

async function handleSubmit() {
  if (!validateForm()) return;
  
  try {
    isSubmitting.value = true;
    
    const url = isEditing.value
      ? `https://api.kaderpintar.id/api/gizi/${form.value.id}`
      : 'https://api.kaderpintar.id/api/gizi';
      
    const method = isEditing.value ? 'PUT' : 'POST';
    const body = {
      ...form.value,
      user_id: form.value.user_id.id
    };
    
    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });
    
    const data = await response.json();
    
    if (response.ok) {
      // toast.success(data.message || 'Data berhasil disimpan');
      resetForm();
      fetchRecords();
    } else {
      throw new Error(data.message || 'Gagal menyimpan data');
    }
  } catch (error) {
    console.error("Error saving data:", error);
    // toast.error(error.message || 'Terjadi kesalahan saat menyimpan data');
  } finally {
    isSubmitting.value = false;
  }
}

function editData(record) {
  form.value = {
    id: record.id,
    user_id: { id: record.user_id, name: record.name },
    weight: record.weight,
    height: record.height,
    age: record.age
  };
  isEditing.value = true;
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function resetForm() {
  form.value = {
    user_id: null,
    weight: null,
    height: null,
    age: null
  };
  errors.value = {};
  isEditing.value = false;
}

async function confirmDelete(id) {
  // const { isConfirmed } = await useConfirmDialog(
  //   'Apakah Anda yakin ingin menghapus data ini?',
  //   'Konfirmasi Penghapusan'
  // );
  
  // if (isConfirmed) {
    deleteData(id);
  // }
}

async function deleteData(id) {
  try {
    const response = await fetch(`https://api.kaderpintar.id/api/gizi/${id}`, {
      method: 'DELETE',
    });
    
    const data = await response.json();
    
    if (response.ok) {
      // toast.success(data.message || 'Data berhasil dihapus');
      fetchRecords();
    } else {
      throw new Error(data.message || 'Gagal menghapus data');
    }
  } catch (error) {
    console.error("Error deleting data:", error);
    // toast.error(error.message || 'Terjadi kesalahan saat menghapus data');
  }
}

function changePage(page) {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page;
    fetchRecords();
  }
}

function openDetailModal(record) {
  selectedRecord.value = record;
  nutritionDetailModal.value.show();
  // Modal is handled by the NutritionDetailModal component
}

function closeDetailModal() {
  selectedRecord.value = null;
}

function formatDate(dateString) {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  if (isNaN(date.getTime())) return dateString;
  
  const options = {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    timeZone: 'Asia/Jakarta'
  };
  
  return date.toLocaleString('id-ID', options);
}

function calculateAgeInMonths(birthDate) {
  if (!birthDate) return null;
  
  const today = new Date();
  const birthDateObj = new Date(birthDate);
  
  if (isNaN(birthDateObj.getTime())) return null;
  
  const yearDiff = today.getFullYear() - birthDateObj.getFullYear();
  const monthDiff = today.getMonth() - birthDateObj.getMonth();
  const dayDiff = today.getDate() - birthDateObj.getDate();
  
  let ageInMonths = yearDiff * 12 + monthDiff;
  
  if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
    ageInMonths--;
  }
  
  return ageInMonths;
}

function shareLink() {
  if (!selectedRecord.value) return;
  
  const runtimeConfig = useRuntimeConfig();
  const baseUrl = runtimeConfig.public.siteUrl || window.location.origin;
  const link = `${baseUrl}/gizi/detail?id=${selectedRecord.value.id}`;
  
  if (navigator.share) {
    navigator.share({
      title: 'Detail Data Gizi Anak',
      text: 'Lihat detail data gizi anak berikut:',
      url: link
    }).catch(err => {
      console.error('Error sharing:', err);
      copyToClipboard(link);
    });
  } else {
    copyToClipboard(link);
  }
}

function copyToClipboard(text) {
  navigator.clipboard.writeText(text)
    // .then(() => toast.success('Link berhasil disalin ke clipboard'))
    .catch(err => {
      console.error('Failed to copy:', err);
      // toast.error('Gagal menyalin link');
    });
}

// Watchers
watch(() => form.value.user_id, (newUser) => {
  if (newUser && newUser.birth_date) {
    form.value.age = calculateAgeInMonths(newUser.birth_date);
  } else {
    form.value.age = null;
  }
});
</script>

<style scoped>
.card {
  transition: transform 0.2s ease-in-out;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0,0,0,0.1);
}

.btn-sm {
  font-size: 0.8rem;
  padding: 0.25rem 0.5rem;
}

.spinner-border {
  vertical-align: middle;
}
</style>