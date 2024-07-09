import signal
import json
import threading
import os


class State:
    def __init__(self, state_file='state.json'):
        self.state_file = state_file
        self._lock = threading.Lock()
        self._stop_event = threading.Event()

        # Load state if exists
        self._load_state()

        # Setup signal handlers
        signal.signal(signal.SIGINT, self._handle_signal)
        signal.signal(signal.SIGTERM, self._handle_signal)

        # Start periodic saving
        self._start_periodic_saving()

    def _load_state(self):
        if os.path.exists(self.state_file):
            with open(self.state_file, 'r') as f:
                self.state = json.load(f)
        else:
            self.state = {
                'last_software_id': 0,
                'last_document_id': 0
            }

    def _save_state(self):
        with self._lock:
            with open(self.state_file, 'w') as f:
                json.dump(self.state, f, indent=4)

    def _handle_signal(self, signum, frame):
        print(f'Received signal {signum}, saving state and exiting...')
        self._save_state()
        self._stop_event.set()
        exit(0)

    def _start_periodic_saving(self):
        def save_periodically():
            while not self._stop_event.wait(60):
                self._save_state()

        threading.Thread(target=save_periodically, daemon=True).start()

    def set_state_var(self, key, value):
        with self._lock:
            self.state[key] = value

    def get_state_var(self, key):
        with self._lock:
            return self.state.get(key)
