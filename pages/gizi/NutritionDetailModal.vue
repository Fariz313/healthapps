<template>
  <div class="modal fade" id="nutritionDetailModal" tabindex="-1" aria-labelledby="nutritionDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title" id="nutritionDetailModalLabel">Detail Data Gizi Pasien</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <!-- Loading State -->
          <div v-if="isLoading" class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
              <span class="visually-hidden">Loading...</span>
            </div>
          </div>

          <!-- Error State -->
          <div v-else-if="error" class="alert alert-danger">
            {{ error }}
          </div>

          <!-- Content -->
          <template v-else-if="record">
            <div class="row mb-4">
              <div class="col-md-6">
                <h5 class="fw-bold">Informasi Pasien</h5>
                <ul class="list-unstyled">
                  <li><strong>Nama:</strong> {{ record.name }}</li>
                  <li><strong>Petugas:</strong> {{ record.recorded_by }}</li>
                  <li><strong>Tanggal Pemeriksaan:</strong> {{ formatDate(record.created_at) }}</li>
                  <li><strong>Usia:</strong> {{ record.age }} bulan</li>
                </ul>
              </div>
              <div class="col-md-6">
                <h5 class="fw-bold">Pengukuran</h5>
                <ul class="list-unstyled">
                  <li><strong>Berat Badan:</strong> {{ record.weight }} kg</li>
                  <li><strong>Tinggi Badan:</strong> {{ record.height }} cm</li>
                  <li><strong>IMT:</strong> {{ calculateBMI(record).toFixed(2) }}</li>
                </ul>
              </div>
            </div>

            <div class="border-top border-bottom py-3 my-3">
              <h4 class="text-center fw-bold">Hasil Penilaian Status Gizi</h4>
            </div>

            <!-- Nutrition Assessment Results -->
            <div class="assessment-results">
              <div class="row">
                <div class="col-md-6 mb-4">
                  <div class="card h-100">
                    <div class="card-header bg-light">
                      <h5 class="mb-0">Berat Badan menurut Umur (BB/U)</h5>
                    </div>
                    <div class="card-body">
                      <NutritionStatusIndicator 
                        :status="getWeightForAgeStatus(record)"
                        :recommendation="getWeightForAgeRecommendation(record)"
                      />
                    </div>
                  </div>
                </div>

                <div class="col-md-6 mb-4">
                  <div class="card h-100">
                    <div class="card-header bg-light">
                      <h5 class="mb-0">Tinggi Badan menurut Umur (TB/U)</h5>
                    </div>
                    <div class="card-body">
                      <NutritionStatusIndicator 
                        :status="getHeightForAgeStatus(record)"
                        :recommendation="getHeightForAgeRecommendation(record)"
                      />
                    </div>
                  </div>
                </div>

                <div class="col-12 mb-4">
                  <div class="card">
                    <div class="card-header bg-light">
                      <h5 class="mb-0">Indeks Massa Tubuh menurut Umur (IMT/U)</h5>
                    </div>
                    <div class="card-body">
                      <NutritionStatusIndicator 
                        :status="getBMIForAgeStatus(record)"
                        :recommendation="getBMIForAgeRecommendation(record)"
                        :detailed="true"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Food Guide -->
            <div class="food-guide mt-5">
              <h4 class="fw-bold border-bottom pb-2">Panduan Makanan</h4>
              
              <div class="alert alert-info">
                <strong>Catatan:</strong> 1 porsi = sekitar 100-150 kalori (sesuaikan dengan usia dan kebutuhan anak)
              </div>

              <div class="row">
                <FoodGuideCategory 
                  title="Karbohidrat"
                  :items="carbohydrateItems"
                  icon="bread-slice"
                />
                
                <FoodGuideCategory 
                  title="Protein Hewani"
                  :items="animalProteinItems"
                  icon="drumstick-bite"
                />
                
                <FoodGuideCategory 
                  title="Protein Nabati"
                  :items="plantProteinItems"
                  icon="seedling"
                />
                
                <FoodGuideCategory 
                  title="Lemak"
                  :items="fatItems"
                  icon="bacon"
                />
                
                <FoodGuideCategory 
                  title="Sayuran"
                  :items="vegetableItems"
                  icon="carrot"
                />
                
                <FoodGuideCategory 
                  title="Buah-buahan"
                  :items="fruitItems"
                  icon="apple-alt"
                />
              </div>
            </div>

            <div class="additional-info mt-4 p-3 bg-light rounded">
              <h5 class="fw-bold">Informasi Tambahan</h5>
              <p>
                Untuk konsultasi lebih lanjut, silahkan menghubungi ahli gizi di puskesmas terdekat atau melalui:
                <a href="https://www.instagram.com/puskesmas_setu1" target="_blank" class="text-primary">
                  Instagram Puskesmas Setu
                </a>
              </p>
            </div>
          </template>
        </div>
        <div class="modal-footer">
          <button 
            type="button" 
            class="btn btn-outline-primary"
            @click="shareResult"
          >
            <i class="fa-solid fa-exclamation me-2"></i>Bagikan Hasil
          </button>
          <button 
            type="button" 
            class="btn btn-secondary" 
            data-bs-dismiss="modal"
          >
            Tutup
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
// import { useToast } from 'vue-toastification';
import NutritionStatusIndicator from './NutritionStatusIndicator.vue';
import FoodGuideCategory from './FoodGuideCategory.vue';

const props = defineProps({
  record: {
    type: Object,
    default: null
  },
  growthStandards: {
    type: Object,
    required: true
  }
});

const emit = defineEmits(['close', 'share']);

// const toast = useToast();
const isLoading = ref(false);
const error = ref(null);
const modalInstance = ref(null);

// Food Guide Data
const carbohydrateItems = ref([
  { name: 'Nasi', portion: '¾ gelas belimbing' },
  { name: 'Bihun', portion: '½ gelas belimbing (50 gr)' },
  { name: 'Jagung segar', portion: '3 buah sedang (45 gr)' },
  { name: 'Kentang', portion: '2 buah sedang (210 gr)' },
  { name: 'Singkong', portion: '1½ potong sedang (120 gr)' },
  { name: 'Makaroni', portion: '½ gelas belimbing (50 gr)' },
  { name: 'Mie', portion: '1 gelas belimbing (50 gr)' },
  { name: 'Roti', portion: '3 sisir (70 gr)' }
]);

const animalProteinItems = ref([
  { name: 'Ikan segar', portion: '1 potong sedang (40 gr)' },
  { name: 'Daging sapi', portion: '1 potong sedang (35 gr)' },
  { name: 'Hati sapi', portion: '1 potong sedang (50 gr)' },
  { name: 'Telur ayam', portion: '1 butir (55 gr)' },
  { name: 'Udang', portion: '5 ekor ukuran sedang (35 gr)' },
  { name: 'Susu sapi', portion: '1 gelas belimbing (200 ml)' }
]);

const plantProteinItems = ref([
  { name: 'Tempe', portion: '2 potong sedang (50 gr)' },
  { name: 'Kacang hijau', portion: '2½ sendok makan (25 gr)' },
  { name: 'Tahu', portion: '2 potong sedang (100 gr)' },
  { name: 'Oncom', portion: '2 potong besar (50 gr)' },
  { name: 'Kembang tahu', portion: '1 lembar (20 gr)' }
]);

const fatItems = ref([
  { name: 'Cumi-cumi', portion: '1 ekor kecil (45 gr)' },
  { name: 'Daging ayam', portion: '1 potong sedang (40 gr)' },
  { name: 'Ikan kembung', portion: '⅓ ekor sedang (30 gr)' },
  { name: 'Ikan lele', portion: '⅓ ekor sedang (40 gr)' },
  { name: 'Kerang', portion: '½ gelas belimbing (90 gr)' },
  { name: 'Putih telur', portion: '2 butir (65 gr)' },
  { name: 'Telur puyuh', portion: '5 butir (55 gr)' }
]);

const vegetableItems = ref([
  { name: 'Sayuran umum', portion: '1 gelas setelah dimasak (100 gr)' }
]);

const fruitItems = ref([
  { name: 'Pisang Ambon', portion: '1 buah ukuran sedang (50 gr)' },
  { name: 'Alpukat', portion: '½ buah ukuran besar (50 gr)' },
  { name: 'Apel', portion: '1 buah kecil (85 gr)' },
  { name: 'Jambu', portion: '1 buah sedang (100 gr)' },
  { name: 'Jeruk', portion: '2 buah ukuran sedang (100 gr)' },
  { name: 'Mangga', portion: '¾ buah ukuran sedang (90 gr)' },
  { name: 'Melon', portion: '1 potong ukuran sedang (90 gr)' },
  { name: 'Pepaya', portion: '1 potong ukuran besar (150 gr)' }
]);

// Lifecycle Hooks
onMounted(() => {
  // Initialize Bootstrap modal
  const modalEl = document.getElementById('nutritionDetailModal');
  modalInstance.value = new bootstrap.Modal(modalEl);
  
  modalEl.addEventListener('hidden.bs.modal', () => {
    emit('close');
  });
});

// Methods
function show() {
  modalInstance.value.show();
}

function hide() {
  modalInstance.value.hide();
}

function calculateBMI(record) {
  if (!record || !record.height || !record.weight) return 0;
  const heightInMeters = record.height / 100;
  return record.weight / (heightInMeters * heightInMeters);
}

function formatDate(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('id-ID', {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
}

function getStandardData(standard, gender, age) {
  if (!props.growthStandards[standard] || !props.growthStandards[standard][gender]) {
    return null;
  }
  
  const standards = props.growthStandards[standard][gender];
  return standards.find(item => item.age === age) || standards[0];
}

function getWeightForAgeStatus(record) {
  if (!record) return null;
  
  const standard = getStandardData('BBU', record.gender === 'L' ? 'L' : 'P', record.age);
  if (!standard) return null;
  
  if (record.weight < standard.m3sd) {
    return {
      level: 'danger',
      title: 'Berat badan sangat kurang',
      description: 'Severely underweight'
    };
  } else if (record.weight < standard.m2sd) {
    return {
      level: 'warning',
      title: 'Berat badan kurang',
      description: 'Underweight'
    };
  } else if (record.weight <= standard.p1sd) {
    return {
      level: 'success',
      title: 'Berat badan normal',
      description: 'Normal weight'
    };
  } else {
    return {
      level: 'warning',
      title: 'Risiko berat badan lebih',
      description: 'Risk of overweight'
    };
  }
}

function getHeightForAgeStatus(record) {
  if (!record) return null;
  
  const standard = getStandardData('TBU', record.gender === 'L' ? 'L' : 'P', record.age);
  if (!standard) return null;
  
  if (record.height < standard.m3sd) {
    return {
      level: 'danger',
      title: 'Sangat pendek',
      description: 'Severely stunted'
    };
  } else if (record.height < standard.m2sd) {
    return {
      level: 'warning',
      title: 'Pendek',
      description: 'Stunted'
    };
  } else if (record.height <= standard.p1sd) {
    return {
      level: 'success',
      title: 'Normal',
      description: 'Normal height'
    };
  } else {
    return {
      level: 'info',
      title: 'Tinggi',
      description: 'Tall'
    };
  }
}

function getBMIForAgeStatus(record) {
  const bmi = calculateBMI(record);
  if (!bmi || !record) return null;
  
  const standard = getStandardData('IMTU', record.gender === 'L' ? 'L' : 'P', record.age);
  if (!standard) return null;
  
  if (bmi < standard.m3sd) {
    return {
      level: 'danger',
      title: 'Gizi sangat kurang',
      description: 'Severely undernourished'
    };
  } else if (bmi < standard.m2sd) {
    return {
      level: 'warning',
      title: 'Gizi kurang',
      description: 'Undernourished'
    };
  } else if (bmi <= standard.p1sd) {
    return {
      level: 'success',
      title: 'Gizi normal',
      description: 'Normal nutrition'
    };
  } else {
    return {
      level: 'danger',
      title: 'Gizi berlebih / Obesitas',
      description: 'Overweight/Obese'
    };
  }
}

function getWeightForAgeRecommendation(record) {
  const status = getWeightForAgeStatus(record);
  if (!status) return null;
  
  switch (status.level) {
    case 'danger':
      return 'Perlu penanganan segera. Konsultasikan dengan ahli gizi untuk rencana penambahan berat badan yang intensif.';
    case 'warning':
      return 'Tingkatkan asupan kalori dan protein dengan makanan bergizi seimbang. Pantau perkembangan berat badan secara rutin.';
    case 'success':
      return 'Pertahankan pola makan bergizi seimbang dan aktivitas fisik yang cukup.';
    default:
      return 'Pantau asupan makanan dan aktivitas fisik untuk menjaga berat badan ideal.';
  }
}

function getHeightForAgeRecommendation(record) {
  const status = getHeightForAgeStatus(record);
  if (!status) return null;
  
  switch (status.level) {
    case 'danger':
      return 'Perlu evaluasi medis menyeluruh. Kemungkinan terdapat masalah gizi kronis atau kondisi medis lain.';
    case 'warning':
      return 'Tingkatkan asupan protein dan mikronutrien penting (zat besi, zinc, kalsium). Pastikan tidur yang cukup.';
    case 'success':
      return 'Pertahankan pola makan bergizi dan aktivitas fisik untuk mendukung pertumbuhan optimal.';
    default:
      return 'Pertumbuhan tinggi badan baik. Lanjutkan pola asuh yang mendukung.';
  }
}

function getBMIForAgeRecommendation(record) {
  const status = getBMIForAgeStatus(record);
  if (!status) return null;
  
  switch (status.level) {
    case 'danger':
      return 'Kondisi gizi sangat kurang membutuhkan penanganan segera. Perlu: 1) Konsultasi dengan ahli gizi, 2) Peningkatan asupan makanan tinggi protein hewani 2x lipat, 3) Makanan selingan bergizi 2x sehari, 4) Pemantauan rutin.';
    case 'warning':
      return 'Kondisi gizi kurang membutuhkan perbaikan pola makan: 1) Tingkatkan protein hewani 2.5x lipat, 2) Berikan makanan selingan bergizi, 3) Pantau perkembangan berat badan, 4) Konsultasi dengan tenaga kesehatan.';
    case 'success':
      return 'Pertahankan pola makan gizi seimbang dengan komposisi: karbohidrat, protein (hewani & nabati), lemak, vitamin, dan mineral. Lanjutkan aktivitas fisik sesuai usia.';
    default:
      return 'Untuk gizi berlebih: 1) Kurangi makanan/minuman manis, 2) Tingkatkan aktivitas fisik, 3) Batasi screen time, 4) Konsultasi dengan ahli gizi untuk diet seimbang.';
  }
}

function shareResult() {
  emit('share', props.record);
}

// Expose methods to parent component
defineExpose({
  show,
  hide
});
</script>

<style scoped>
.modal-xl {
  max-width: 1200px;
}

.assessment-results {
  background-color: #f8f9fa;
  padding: 1.5rem;
  border-radius: 0.5rem;
}

.food-guide {
  background-color: white;
  padding: 1.5rem;
  border-radius: 0.5rem;
  box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

.card {
  border: none;
  box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
  transition: transform 0.2s;
}

.card:hover {
  transform: translateY(-2px);
}

.card-header {
  font-weight: 600;
}

.additional-info {
  border-left: 4px solid var(--bs-primary);
}
</style>