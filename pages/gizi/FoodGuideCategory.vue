<template>
  <div class="col-md-6 col-lg-4 mb-4">
    <div class="food-category-card h-100">
      <div class="card h-100 border-0 shadow-sm">
        <div class="card-header d-flex align-items-center">
          <div class="category-icon me-2">
            <i class="fas" :class="`fa-${icon}`"></i>
          </div>
          <h5 class="mb-0">{{ title }}</h5>
        </div>
        <div class="card-body">
          <ul class="list-unstyled mb-0">
            <li 
              v-for="(item, index) in items" 
              :key="index"
              class="d-flex mb-2"
            >
              <div class="flex-grow-1">
                <strong>{{ item.name }}</strong>
                <div class="text-muted small">{{ item.portion }}</div>
              </div>
              <div class="text-end">
                <button 
                  class="btn btn-sm btn-outline-primary"
                  @click="showPortionExample(item)"
                >
                  <i class="fas fa-image"></i>
                </button>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// import { useToast } from 'vue-toastification';

const props = defineProps({
  title: {
    type: String,
    required: true
  },
  items: {
    type: Array,
    required: true,
    validator: (value) => {
      return value.every(item => 'name' in item && 'portion' in item);
    }
  },
  icon: {
    type: String,
    default: 'utensils'
  }
});

const emit = defineEmits(['showExample']);

// const toast = useToast();

function showPortionExample(item) {
//   toast.info(`Contoh porsi: ${item.name} (${item.portion})`, {
//     timeout: 3000
//   });
  emit('showExample', item);
}
</script>

<style scoped>
.food-category-card {
  transition: transform 0.2s ease;
}

.food-category-card:hover {
  transform: translateY(-3px);
}

.card-header {
  background-color: rgba(var(--bs-primary-rgb), 0.1);
  color: var(--bs-primary);
  font-weight: 600;
}

.category-icon {
  width: 24px;
  text-align: center;
}

.list-unstyled li {
  padding: 0.5rem 0;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.list-unstyled li:last-child {
  border-bottom: none;
}

.btn-sm {
  padding: 0.15rem 0.4rem;
  font-size: 0.7rem;
}
</style>