<template>
  <div class="pb-32 bg-sky-900">
    <Disclosure as="nav" class="border-b border-sky-400/25 bg-sky-800" v-slot="{ open }">
      <div class="mx-auto max-w-7xl px-4">
        <div class="relative flex h-16 items-center justify-between">
          <div class="flex items-center px-2 lg:px-0">
            <div class="shrink-0">
              <h1 class="text-xl font-medium tracking-tight text-sky-200">
                <span class="text-white font-bold">IETF {{ state.meeting.meetingNumber }}</span>
                Side Meetings
              </h1>
            </div>
          </div>
          <div class="flex lg:hidden">
            <!-- Mobile menu button -->
            <DisclosureButton
              class="relative inline-flex items-center justify-center rounded-md bg-sky-600 p-2 text-sky-200 hover:bg-sky-500/75 hover:text-white focus:outline-2 focus:outline-offset-2 focus:outline-white dark:bg-sky-800 dark:hover:bg-sky-700/75">
              <span class="absolute -inset-0.5"></span>
              <span class="sr-only">Open main menu</span>
              <Bars3Icon v-if="!open" class="block size-6" aria-hidden="true" />
              <XMarkIcon v-else class="block size-6" aria-hidden="true" />
            </DisclosureButton>
          </div>
          <div class="hidden lg:ml-4 lg:block">
            <div class="flex items-center">
              <a
                href="https://ietf.cal.com/side-meetings"
                target="_blank"
                class="relative inline-flex items-center gap-x-1.5 rounded-md bg-sky-500 px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-sky-400 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-sky-500 dark:shadow-none">
                <PlusIcon class="-ml-0.5 size-5" aria-hidden="true" />
                Request Meeting Room
              </a>
            </div>
          </div>
        </div>
      </div>
    </Disclosure>
    <header class="py-8">
      <div class="mx-auto max-w-7xl px-4">
        <div class="flex items-center px-2 lg:px-0">
          <div class="grow">
            <h2 class="text-2xl font-semibold tracking-tight text-white">
              {{ state.meeting.meetingLocation }}
            </h2>
            <h2 class="text-xl font-medium tracking-tight text-sky-200">{{ meetingDates }}</h2>
          </div>
          <div class="shrink-0">
            <label for="timezone" class="block text-sm/6 font-medium text-sky-200">
              Timezone
            </label>
            <div class="grid grid-cols-1">
              <select
                id="timezone"
                name="timezone"
                v-model="state.timezone"
                class="col-start-1 row-start-1 w-full appearance-none rounded-md py-1.5 pr-8 pl-3 text-base outline-1 -outline-offset-1 focus-visible:outline-2 focus-visible:-outline-offset-2 sm:text-sm/6 bg-white/5 text-white outline-white/10 *:bg-gray-800 focus-visible:outline-sky-500">
                <option v-for="tz of timezones" :key="tz">{{ tz }}</option>
              </select>
              <ChevronDownIcon
                class="pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end sm:size-4 text-gray-400"
                aria-hidden="true" />
            </div>
          </div>
        </div>
      </div>
    </header>
  </div>

  <main class="-mt-32">
    <div class="mx-auto max-w-7xl px-4 pb-12">
      <div class="grid grid-cols-5 gap-1">
        <div
          class="bg-sky-950 rounded-md px-2 py-2 shadow-xl outline-1 -outline-offset-1 outline-white/10"
          v-for="day of state.days"
          :key="day.id">
          <h3 class="font-medium text-white">{{ day.name }}</h3>
          <div class="text-xs/tight font-medium text-sky-300 border-b border-gray-400/25 pb-2">
            {{ day.dateLabel }}
          </div>
          <div class="grid grid-cols-1 gap-2 mt-2">
            <div
              v-if="day.bookings.length < 1"
              class="bg-black/30 rounded-sm px-2 py-20 text-center italic text-sm text-white/70">
              No side meeting booked yet.
            </div>
            <div
              v-for="booking of day.bookings"
              :key="booking.id"
              class="bg-emerald-800 rounded-sm px-2 py-1 text-sm">
              <div class="font-medium text-emerald-100">8:00-9:00</div>
              <div class="font-bold text-white">McGill</div>
              <div class="text-white">Zero Trust</div>
            </div>
            <!-- <div class="bg-yellow-700 rounded-sm px-2 py-1 text-sm">
              <div class="font-medium text-yellow-100">9:15-9:45</div>
              <div class="font-bold text-white">McGill</div>
              <div class="text-white">SONiC Routing Workshop</div>
            </div>
            <div class="bg-purple-700 rounded-sm px-2 py-1 text-sm">
              <div class="font-medium text-purple-100">13:00-14:00</div>
              <div class="font-bold text-white">McGill</div>
              <div class="text-white">Interface to In-Network Computing Functions (I2ICF)</div>
            </div> -->
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

<script setup>
import {
  Disclosure,
  DisclosureButton,
  DisclosurePanel,
  Menu,
  MenuButton,
  MenuItem,
  MenuItems
} from '@headlessui/vue'
import { Bars3Icon, XMarkIcon } from '@heroicons/vue/24/outline'
import { PlusIcon } from '@heroicons/vue/20/solid'
import { ChevronDownIcon } from '@heroicons/vue/16/solid'
import { computed, reactive } from 'vue'
import { DateTime } from 'luxon'

const state = reactive({
  meeting: {
    meetingNumber: '---',
    meetingLocation: '---',
    startDate: DateTime.fromISO('2000-01-01'),
    endDate: DateTime.fromISO('2000-01-02'),
    timezone: 'America/New_York'
  },
  timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
  days: []
})

const timezones = Intl.supportedValuesOf('timeZone')

const meetingDates = computed(() => {
  if (state.meeting.startDate.month === state.meeting.endDate.month) {
    return `${state.meeting.startDate.toFormat('MMMM d')} - ${state.meeting.endDate.toFormat('d, y')}`
  } else {
    return `${state.meeting.startDate.toFormat('MMMM d')} - ${state.meeting.endDate.toFormat('MMMM d, y')}`
  }
})

async function fetchData() {
  try {
    const resp = await fetch('/_data').then((r) => r.json())
    state.timezone = resp.meeting.timezone
    state.meeting = {
      ...resp.meeting,
      startDate: DateTime.fromISO(resp.meeting.startDate, { zone: state.timezone }),
      endDate: DateTime.fromISO(resp.meeting.endDate, { zone: state.timezone }).endOf('day')
    }
    state.days = []
    let day = state.meeting.startDate
    while (day < state.meeting.endDate) {
      state.days.push({
        id: day.toISODate(),
        name: day.weekdayLong,
        dateLabel: day.toFormat('LLLL d, yyyy'),
        bookings: []
      })
      day = day.plus({ days: 1 })
    }
  } catch (err) {
    console.warn(err)
  }
}

fetchData()
</script>
