# projet-annotation-genome
**Annotation d’un fragment génomique de Lactococcus lactis**


Ce projet a pour objectif l’annotation d’un fragment génomique de la bactérie Lactococcus lactis. L’annotation permet d’identifier les gènes codants pour des protéines (CDS), les ARN non codants, les sites régulateurs (promoteurs, terminateurs), et d’inférer la fonction et la localisation cellulaire des protéines identifiées.

L’approche combine plusieurs méthodes bioinformatiques pour fournir une annotation robuste et fiable :

Détection de ORF (Open Reading Frames) avec ORFfinder.

Analyse statistique des régions codantes avec GeneMark et GeneMark.hmm.

Identification des sites de fixation du ribosome (RBS) avec scan_for_matches.

Prédiction des promoteurs et terminateurs.

Annotation fonctionnelle via BLASTP et détection de domaines avec InterProScan et CD-Search.

Analyse de la localisation cellulaire et des peptides signal avec SignalP et DeepTMHMM.

**Méthodologie**

ORF Detection :Utilisation de ORFfinder pour identifier les cadres ouverts de lecture (≥300 nt).

Gene Prediction:
GeneMark et GeneMark.hmm pour identifier les CDS.
Sortie graphique pour visualiser les probabilités de codage.

RBS Identification :Utilisation de motifs consensus stricts, motifs dégénérés et matrices poids-positions (PWM) via scan_for_matches.

Annotation des unités de transcription :Recherche de promoteurs sigma A et terminateurs indépendants.

Annotation fonctionnelle: 
BLASTP pour l’homologie protéique.
InterProScan/CD-Search pour détection des domaines fonctionnels.

Localisation cellulaire:
SignalP pour les peptides signal.
DeepTMHMM pour les régions transmembranaires.

**Résultats principaux**

Identification de 6 CDS majeurs dans le fragment analysé.

Certaines protéines appartiennent à la famille des lanthionine synthétases (LanC) ou à la famille S8 des peptidases.

Peptides signal détectés pour la séquence 5, indiquant une sécrétion extracellulaire.

Cartographie préliminaire des unités de transcription : promoteur-CDS-terminateur.
