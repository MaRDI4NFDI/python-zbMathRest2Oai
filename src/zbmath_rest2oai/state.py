import signal
import pickle
import threading
import os


class State:
    def __init__(self, state_file='state.pkl'):
        self.state_file = state_file
        self._lock = threading.Lock()
        self.last_software_id = None
        self.last_document_id = None
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
            with open(self.state_file, 'rb') as f:
                state = pickle.load(f)
                self.last_software_id = state.get('last_software_id')
                self.last_document_id = state.get('last_document_id')
        else:
            self.last_software_id = 0
            self.last_document_id = 0

    def _save_state(self):
        with self._lock:
            state = {
                'last_software_id': self.last_software_id,
                'last_document_id': self.last_document_id
            }
            with open(self.state_file, 'wb') as f:
                pickle.dump(state, f)

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

    def update_state(self, last_software_id, last_document_id):
        with self._lock:
            self.last_software_id = last_software_id
            self.last_document_id = last_document_id

    # Getter and Setter for last_document_id
    @property
    def last_document_id(self):
        return self._last_document_id

    @last_document_id.setter
    def last_document_id(self, value):
        self._last_document_id = value

    # Getter and Setter for last_software_id (if needed)
    @property
    def last_software_id(self):
        return self._last_software_id

    @last_software_id.setter
    def last_software_id(self, value):
        self._last_software_id = value
