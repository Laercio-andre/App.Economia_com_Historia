// src/main/java/com/economiangola/domain/entity/ProgressoUsuario.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Table(name = "progresso_usuario", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"usuario_id", "conteudo_id"})
})
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgressoUsuario extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conteudo_id", nullable = false)
    private Conteudo conteudo;

    @Column(name = "percentual_completo", nullable = false)
    @Builder.Default
    private Integer percentualCompleto = 0;

    @Column(name = "ultima_interacao")
    private Instant ultimaInteracao;

    @Column(name = "concluido_em")
    private Instant concluidoEm;
}
