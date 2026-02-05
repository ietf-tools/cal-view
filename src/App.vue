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
                tabindex="1"
                class="relative inline-flex items-center gap-x-1.5 rounded-md bg-sky-500 px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-sky-400 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-sky-500">
                <PlusIcon class="-ml-0.5 size-5" aria-hidden="true" />
                Book a Side Meeting
              </a>
            </div>
          </div>
        </div>
      </div>
      <DisclosurePanel class="lg:hidden">
        <!-- Mobile dropdown menu -->
        <div class="border-t border-sky-700 py-4 px-5 dark:border-sky-900">
          <a
            href="https://ietf.cal.com/side-meetings"
            target="_blank"
            tabindex="1"
            class="relative flex items-center gap-x-1.5 rounded-md bg-sky-500 px-3 py-2 text-sm font-semibold text-white shadow-xs hover:bg-sky-400 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-sky-500">
            <PlusIcon class="-ml-0.5 size-5" aria-hidden="true" />
            Book a Side Meeting
          </a>
        </div>
      </DisclosurePanel>
    </Disclosure>
    <header class="py-8">
      <div class="mx-auto max-w-7xl px-4">
        <div class="block sm:flex items-center px-2 lg:px-0">
          <div class="grow">
            <h2 class="text-2xl font-semibold tracking-tight text-white">
              {{ state.meeting.meetingLocation }}
            </h2>
            <h2 class="text-xl font-medium tracking-tight text-sky-200">{{ meetingDates }}</h2>
          </div>
          <div class="shrink-0 mt-5 sm:mt-0">
            <div class="flex items-center text-sky-200 text-sm/6">
              <label for="timezone" class="font-semibold">Timezone</label>
              <span class="inline-block pl-2 pr-1">(</span>
              <a
                href="#"
                @click.stop="setTimezone(state.meeting.timezone)"
                class="font-normal text-sky-300 hover:text-white focus-within:text-white"
                >Meeting</a
              >
              <span class="inline-block px-1">&middot;</span>
              <a
                href="#"
                @click.stop="setTimezone()"
                class="font-normal text-sky-300 hover:text-white focus-within:text-white"
                >Local</a
              >
              <span class="inline-block px-1">&middot;</span>
              <a
                href="#"
                @click.stop="setTimezone('Europe/London')"
                class="font-normal text-sky-300 hover:text-white focus-within:text-white"
                >UTC</a
              >
              <span class="inline-block pl-1">)</span>
            </div>
            <div class="grid grid-cols-1">
              <select
                id="timezone"
                name="timezone"
                tabindex="2"
                v-model="state.timezone"
                class="col-start-1 row-start-1 w-full appearance-none rounded-md py-1.5 pr-8 pl-3 text-base outline-1 -outline-offset-1 hover:outline-1 hover:-outline-offset-2 hover:outline-sky-600 focus-visible:outline-2 focus-visible:-outline-offset-2 sm:text-sm/6 bg-white/5 text-white outline-white/10 *:bg-gray-800 focus-visible:outline-sky-500">
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
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-1">
        <div
          class="bg-sky-950 rounded-md px-2 py-2 shadow-xl outline-1 -outline-offset-1 outline-white/10"
          v-for="day of days"
          :key="day.id">
          <h3 class="font-semibold text-white text-center">{{ day.name }}</h3>
          <div
            class="text-sm/tight font-medium text-sky-300 border-b border-gray-400/25 pb-2 text-center">
            {{ day.dateLabel }}
          </div>
          <div class="grid grid-cols-1 gap-2 mt-2">
            <div
              v-if="day.bookings.length < 1"
              class="bg-black/10 rounded-sm px-2 py-20 text-center italic text-sm text-sky-200/80">
              No side meetings have been booked yet.
            </div>
            <div
              v-for="booking of day.bookings"
              :key="booking.id"
              @click="showDetails(booking)"
              :tabindex="booking.orderIdx + 3"
              :class="
                booking.room.bgColor +
                ' rounded-sm p-2 text-sm border-l border-l-white/30 border-t border-t-white/30 shadow hover:outline-2 hover:outline-offset-2 hover:outline-sky-200/80 focus:outline-2 focus:outline-offset-2 focus:outline-sky-200/80 cursor-pointer'
              ">
              <div :class="booking.room.textColor + ' font-semibold'">
                {{ booking.timeDisplay }}
              </div>
              <div class="font-bold text-white">{{ booking.roomName }}</div>
              <div class="text-white">{{ booking.title }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>

  <TransitionRoot appear :show="state.detailsShown" as="template">
    <Dialog as="div" @close="closeDetails" class="relative z-10">
      <TransitionChild
        as="template"
        enter="duration-300 ease-out"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="duration-200 ease-in"
        leave-from="opacity-100"
        leave-to="opacity-0">
        <div class="fixed inset-0 bg-black/75"></div>
      </TransitionChild>
      <div class="fixed inset-0 overflow-y-auto">
        <div class="flex min-h-full items-center justify-center p-4 text-center">
          <TransitionChild
            as="template"
            enter="duration-300 ease-out"
            enter-from="opacity-0 scale-95"
            enter-to="opacity-100 scale-100"
            leave="duration-200 ease-in"
            leave-from="opacity-100 scale-100"
            leave-to="opacity-0 scale-95">
            <DialogPanel
              class="w-full max-w-xl relative transform overflow-hidden rounded-2xl text-white text-left align-middle shadow-xl transition-all bg-gray-900">
              <div class="absolute top-0 right-0 hidden pt-4 pr-4 sm:block">
                <button
                  type="button"
                  class="rounded-mdfocus:outline-2 focus:outline-offset-2 bg-gray-800 hover:text-gray-300 focus:outline-white cursor-pointer"
                  @click="closeDetails">
                  <span class="sr-only">Close</span>
                  <XMarkIcon class="size-6" aria-hidden="true" />
                </button>
              </div>
              <div class="bg-gray-800 p-6">
                <div class="text-sm font-medium text-sky-200">
                  {{ state.details.dayDisplay }}
                </div>
                <DialogTitle as="h3" class="text-lg font-semibold text-white">{{
                  state.details.title
                }}</DialogTitle>
                <DialogDescription
                  as="div"
                  :class="state.details.room.textColor + ' font-semibold mt-2'">
                  <div>
                    {{ state.details.timeDisplay }}
                    <span class="text-sm font-normal tracking-tight">( {{ state.timezone }} )</span>
                    &middot;
                    {{ state.details.roomName }}
                  </div>
                </DialogDescription>
                <div class="mt-4 text-sm">{{ state.details.description }}</div>
                <div class="flex items-center mt-4 text-sm">
                  <span class="font-semibold mr-2">Organizer:</span>
                  <span
                    >{{ state.details.organizerName }} &middot;
                    <a
                      class="text-sky-300 hover:text-sky-200"
                      :href="'mailto:' + state.details.organizerEmail"
                      >{{ state.details.organizerEmail }}</a
                    >
                  </span>
                </div>
              </div>
              <div class="px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 bg-gray-900">
                <a
                  class="inline-flex w-full justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-xs sm:ml-3 sm:w-auto bg-sky-600 hover:bg-sky-500 cursor-pointer"
                  :href="state.details.location"
                  target="_blank">
                  Join Meeting Call
                </a>
                <button
                  type="button"
                  class="mt-3 inline-flex w-full justify-center rounded-md px-3 py-2 text-sm font-semibold shadow-xs inset-ring sm:mt-0 sm:w-auto bg-white/10 text-white inset-ring-white/5 hover:bg-white/20 cursor-pointer"
                  @click="closeDetails">
                  Close
                </button>
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<script setup>
import {
  Dialog,
  DialogPanel,
  DialogTitle,
  DialogDescription,
  Disclosure,
  DisclosureButton,
  DisclosurePanel,
  TransitionRoot,
  TransitionChild
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
  rooms: [],
  bookings: [],
  timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
  detailsShown: false,
  firstFetch: true,
  details: {}
})

const timezones = Intl.supportedValuesOf('timeZone')

const meetingDates = computed(() => {
  const start = state.meeting.startDate.setZone(state.timezone)
  const end = state.meeting.endDate.setZone(state.timezone)
  if (start.month === end.month) {
    return `${start.toFormat('MMMM d')} - ${end.toFormat('d, y')}`
  } else {
    return `${start.toFormat('MMMM d')} - ${end.toFormat('MMMM d, y')}`
  }
})

const days = computed(() => {
  let tempDays = []
  let day = state.meeting.startDate.setZone(state.timezone)
  while (day < state.meeting.endDate) {
    const dayStart = day.setZone(state.timezone).startOf('day')
    const dayEnd = day.setZone(state.timezone).endOf('day')
    tempDays.push({
      id: day.toISODate(),
      name: day.weekdayLong,
      dateLabel: day.toFormat('LLLL d, yyyy'),
      bookings: state.bookings
        .filter((b) => b.start >= dayStart && b.start <= dayEnd)
        .map((b) => ({
          ...b,
          start: b.start.setZone(state.timezone),
          end: b.end.setZone(state.timezone),
          timeDisplay: `${b.start.setZone(state.timezone).toFormat('H:mm')}-${b.end.setZone(state.timezone).toFormat('H:mm')}`
        }))
    })
    day = day.plus({ days: 1 })
  }
  return tempDays
})

const bgColors = [
  'bg-yellow-600',
  'bg-pink-700',
  'bg-purple-800',
  'bg-emerald-800',
  'bg-indigo-800',
  'bg-sky-800'
]
const textColors = [
  'text-yellow-100',
  'text-pink-200',
  'text-purple-200',
  'text-emerald-200',
  'text-indigo-200',
  'text-sky-200'
]

function setTimezone(newTz) {
  state.timezone = newTz || Intl.DateTimeFormat().resolvedOptions().timeZone
  return false
}

function closeDetails() {
  state.detailsShown = false
}

function showDetails(booking) {
  state.details = {
    ...booking,
    dayDisplay: booking.start.toFormat('cccc, LLLL d, yyyy')
  }
  state.detailsShown = true
}

async function fetchData() {
  try {
    const resp = await fetch('/_data').then((r) => r.json())
    if (state.firstFetch) {
      state.timezone = resp.meeting.timezone
      state.firstFetch = false
    }
    state.meeting = {
      ...resp.meeting,
      startDate: DateTime.fromISO(resp.meeting.startDate, { zone: resp.meeting.timezone }),
      endDate: DateTime.fromISO(resp.meeting.endDate, { zone: resp.meeting.timezone }).endOf('day')
    }
    state.rooms = resp.rooms.map((r, rIdx) => {
      return {
        ...r,
        bgColor: bgColors[rIdx] ?? 'bg-sky-800',
        textColor: textColors[rIdx] ?? 'bg-sky-800'
      }
    })
    state.bookings = resp.bookings.map((b, idx) => {
      const start = DateTime.fromISO(b.start, { zone: state.meeting.timezone })
      const end = DateTime.fromISO(b.end, { zone: state.meeting.timezone })
      return {
        ...b,
        start,
        end,
        timeDisplay: `${start.toFormat('H:mm')}-${end.toFormat('H:mm')}`,
        room: state.rooms.find((r) => r.id === b.roomId),
        orderIdx: idx
      }
    })
  } catch (err) {
    console.warn(err)
  }
}

fetchData()
</script>
