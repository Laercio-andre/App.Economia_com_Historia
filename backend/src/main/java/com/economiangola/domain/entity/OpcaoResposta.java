// src/main/java/com/economiangola/domain/entity/OpcaoResposta.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "opcoes_resposta")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OpcaoResposta extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pergunta_id", nullable = false)
    private Pergunta pergunta;

    @Column(name = "texto", nullable = false, length = 500)
    private String texto;

    @Column(name = "correta", nullable = false)
    @Builder.Default
    private Boolean correta = false;

    @Column(name = "ordem", nullable = false)
    @Builder.Default
    private Integer ordem = 0;
}
