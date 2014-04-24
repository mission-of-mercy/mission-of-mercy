chartQueued = <%= @queued %>

unless chartQueued
  mom.utilities.openInBackground '<%= chart_patient_path(@patient, format: "pdf") %>'
