from dask.distributed import Client
from lpc_dask import HTCondorCluster
import socket
import time

extra = ['--worker-port 10002:10100']

hostname = socket.gethostname()

cluster = HTCondorCluster(scheduler_options = {'host': f'{hostname}:10000'},
                          cores=1, 
                          memory="4GB", 
                          disk="2GB", 
                          python='python',
                          nanny=False,
                          extra=extra
)

cluster.scale(jobs=10)

client = Client(cluster)

from coffea import hist, processor, nanoevents

# register our candidate behaviors
from coffea.nanoevents.methods import candidate

class MyProcessor(processor.ProcessorABC):
    def __init__(self):
        self._accumulator = processor.dict_accumulator({
            "sumw": processor.defaultdict_accumulator(float),
            "mass": hist.Hist(
                "Events",
                hist.Cat("dataset", "Dataset"),
                hist.Bin("mass", "$m_{\mu\mu}$ [GeV]", 60, 60, 120),
            ),
        })

    @property
    def accumulator(self):
        return self._accumulator

    def process(self, events):
        output = self.accumulator.identity()

        dataset = events.metadata['dataset']
        muons = events.Muon

        cut = (muons.counts == 2) & (muons.charge.sum() == 0)
        # add first and second muon in every event together
        dimuon = muons[cut][:, 0] + muons[cut][:, 1]
        
        output["sumw"][dataset] += len(events)
        output["mass"].fill(
            dataset=dataset,
            mass=dimuon.mass,
        )

        return output

    def postprocess(self, accumulator):
        return accumulator

fileset = {
    'DoubleMuon': [
        'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/Run2012B_DoubleMuParked.root',
        'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/Run2012C_DoubleMuParked.root',
    ],
    'ZZ to 4mu': [
        'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/ZZTo4mu.root'
    ]
}

exe_args = {
    'client': client,
    'savemetrics': True,
    'schema': processor.NanoEvents,
    'align_clusters': True
}

while len(client.ncores()) < 4:
    print('Waiting for more cores to spin up, currently there are {0} available...'.format(len(client.ncores())))
    print('Dask client info ->', client)
    time.sleep(10)

proc = MyProcessor()

hists = processor.run_uproot_job(fileset,
                                 treename="Events",
                                 processor_instance=proc,
                                 executor=processor.dask_executor,
                                 executor_args=exe_args)

print(hists)
