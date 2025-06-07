<template>
  <div class="nutrition-status-indicator">
    <div class="status-header d-flex align-items-center mb-3">
      <div 
        class="status-badge me-3"
        :class="`bg-${status.level}`"
      >
        <i class="fas" :class="statusIcon"></i>
      </div>
      <div>
        <h5 class="mb-0 fw-bold">{{ status.title }}</h5>
        <small class="text-muted">{{ status.description }}</small>
      </div>
    </div>
    
    <div 
      class="status-content p-3 rounded"
      :class="`bg-${status.level}-subtle`"
    >
      <h6 class="fw-bold mb-2">Rekomendasi:</h6>
      <p class="mb-0">{{ recommendation }}</p>
      
      <template v-if="detailed">
        <hr>
        <div class="detailed-advice">
          <h6 class="fw-bold mb-2">Panduan Khusus:</h6>
          <ul class="mb-0">
            <li v-for="(item, index) in detailedAdvice" :key="index">
              {{ item }}
            </li>
          </ul>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  status: {
    type: Object,
    required: true,
    validator: (value) => {
      return ['level', 'title', 'description'].every(prop => prop in value);
    }
  },
  recommendation: {
    type: String,
    required: true
  },
  detailed: {
    type: Boolean,
    default: false
  }
});

const statusIcon = computed(() => {
  switch (props.status.level) {
    case 'danger':
      return 'fa-exclamation-triangle';
    case 'warning':
      return 'fa-exclamation-circle';
    case 'success':
      return 'fa-check-circle';
    default:
      return 'fa-info-circle';
  }
});

const detailedAdvice = computed(() => {
  if (!props.detailed) return [];
  
  switch (props.status.level) {
    case 'danger':
      return [
        'Konsultasi segera dengan ahli gizi',
        'Peningkatan asupan protein hewani 2x lipat',
        'Tambahkan 2 makanan selingan bergizi sehari',
        'Pemantauan berat badan mingguan'
      ];
    case 'warning':
      return [
        'Tingkatkan protein hewani 2.5x lipat',
        'Berikan makanan selingan bergizi',
        'Pantau perkembangan berat badan',
        'Konsultasi dengan tenaga kesehatan'
      ];
    case 'success':
      return [
        'Pola makan gizi seimbang',
        'Aktivitas fisik sesuai usia',
        'Pantau pertumbuhan rutin',
        'Jaga pola tidur yang cukup'
      ];
    default:
      return [
        'Kurangi makanan/minuman manis',
        'Tingkatkan aktivitas fisik',
        'Batasi screen time',
        'Konsultasi dengan ahli gizi'
      ];
  }
});
</script>

<style scoped>
.nutrition-status-indicator {
  font-size: 0.9rem;
}

.status-badge {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.1rem;
}

.status-content {
  border-left: 3px solid;
  border-color: inherit;
}

.bg-danger-subtle {
  background-color: rgba(220, 53, 69, 0.1);
  border-color: var(--bs-danger);
}

.bg-warning-subtle {
  background-color: rgba(255, 193, 7, 0.1);
  border-color: var(--bs-warning);
}

.bg-success-subtle {
  background-color: rgba(25, 135, 84, 0.1);
  border-color: var(--bs-success);
}

.bg-info-subtle {
  background-color: rgba(13, 202, 240, 0.1);
  border-color: var(--bs-info);
}

.detailed-advice ul {
  padding-left: 1.2rem;
}

.detailed-advice li {
  margin-bottom: 0.3rem;
}
</style>